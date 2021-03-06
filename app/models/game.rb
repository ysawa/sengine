# -*- coding: utf-8 -*-

class Game
  @queue = :game_serve

  class CannotTakeMovement < StandardError; end
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  field :handicap, type: String
  field :finished_at, type: Time
  field :given_up, type: Boolean
  field :number, type: Integer, default: 0
  field :playing, type: Boolean, default: true
  field :theme, type: String, default: 'default'
  field :user_noticed_ids, type: Array, default: []

  THEMES = %w(default test)
  HANDICAPS = %w(hi ka two four six eight ten)

  has_many :boards
  has_many :comments, as: :commentable
  has_many :movements
  belongs_to :sente_user, class_name: 'User', inverse_of: :sente_games
  belongs_to :gote_user, class_name: 'User', inverse_of: :gote_games
  belongs_to :won_user, class_name: 'User', inverse_of: :won_games
  belongs_to :lost_user, class_name: 'User', inverse_of: :lost_games
  belongs_to :author, class_name: 'User', inverse_of: :created_games
  before_destroy :destroy_boards

  attr_protected :user_noticed_ids

  def append_user_noticed(user)
    self.user_noticed_ids << user._id
    self.user_noticed_ids.uniq!
    self.user_noticed_ids
  end

  def apply_score_changes!
    return false if handicapped?
    calculator = ScoreCalculator.new
    calculator.winner_score = self.won_user.score
    calculator.loser_score = self.lost_user.score
    calculator.calculate
    self.won_user.write_grade_with_score(calculator.winner_next_score)
    self.lost_user.write_grade_with_score(calculator.loser_next_score)
    if self.won_user.valid? && self.lost_user.valid?
      self.won_user.save
      self.lost_user.save
      true
    else
      false
    end
  end

  def async_deliver_created_notices
    Resque.enqueue(Game, id, :deliver_created_notices)
  end

  def check_if_playing
    if self.playing?
      board = self.boards.last
      if board.ou_in_sente_hand?
        # sente win
        self.won_user = self.sente_user
        self.lost_user = self.gote_user
        false
      elsif board.ou_in_gote_hand?
        # gote win
        self.won_user = self.gote_user
        self.lost_user = self.sente_user
        false
      else
        true
      end
    else
      false
    end
  end

  def check_and_save_if_playing
    if self.playing?
      self.playing = check_if_playing
      unless self.playing
        # game finished first
        self.finished_at = Time.now
        apply_score_changes!
        create_facebook_won_feed
        save
        return false
      end
      save
    else
      false
    end
  end

  def create_facebook_created_feed(options = {})
    locale = self.author.locale
    options = options.stringify_keys
    site_root = Sengine.system.site[:root_url]
    options['name'] = "#{self.sente_user.name} vs #{self.gote_user.name}"
    game_path = "/games/#{self.id}"
    options['link'] = "#{site_root}#{game_path}"
    options['caption'] = site_root.sub(/^(http|https):\/\//, '')
    options['description'] = I18n.t('site.meta.description', locale: locale)
    message = I18n.t('feeds.game_created',
      sente: self.sente_user.name,
      gote: self.gote_user.name,
      locale: locale)
    self.author.create_facebook_feed(message, options)
  end

  def create_facebook_created_notification(notified = nil, options = {})
    notified = self.opponent unless notified
    return false unless notified && notified.facebook_id
    locale = notified.locale
    options = options.stringify_keys
    site_root = Sengine.system.site[:root_url]
    game_path = "?redirect=/games/#{self.id}"
    options['href'] = "#{URI.escape game_path}"
    message = I18n.t('feeds.game_created',
      sente: self.sente_user.name,
      gote: self.gote_user.name,
      locale: locale)
    self.author.create_facebook_notification(notified, message, options)
  end

  def create_facebook_moved_notification(notified = nil, options = {})
    last_movement = self.movements.last
    return false unless last_movement
    if last_movement.sente?
      user = self.sente_user
      notified = self.gote_user unless notified
    else
      user = self.gote_user
      notified = self.sente_user unless notified
    end
    return false unless notified && notified.facebook_id
    locale = notified.locale
    options = options.stringify_keys
    site_root = Sengine.system.site[:root_url]
    game_path = "?redirect=/games/#{self.id}"
    options['href'] = "#{URI.escape game_path}"
    message = I18n.t('feeds.game_moved',
      user: user.name,
      locale: locale)
    self.author.create_facebook_notification(notified, message, options)
  end

  def create_facebook_won_feed(options = {})
    locale = self.won_user.locale
    options = options.stringify_keys
    site_root = Sengine.system.site[:root_url]
    options['name'] = "#{self.sente_user.name} vs #{self.gote_user.name}"
    game_path = "/games/#{self.id}"
    options['link'] = "#{site_root}#{game_path}"
    options['caption'] = site_root.sub(/^(http|https):\/\//, '')
    options['description'] = I18n.t('site.meta.description', locale: locale)
    if self.won_user.grade_increased
      message = I18n.t('feeds.game_finished_and_upgrade',
        winner: self.won_user.name,
        loser: self.lost_user.name,
        grade: I18n.t("user.grades.grade_#{self.won_user.grade}", locale: locale),
        locale: locale)
      self.won_user.create_facebook_feed(message, options)
    else
      message = I18n.t('feeds.game_finished',
        winner: self.won_user.name,
        loser: self.lost_user.name,
        locale: locale)
      self.won_user.create_facebook_feed(message, options)
    end
  end

  def create_first_board
    board = Board.hirate
    if handicapped?
      board.write_attributes({ sente: true, number: 0 })
      case self.handicap
      when 'hi'
        board.p_82 = Piece::NONE
      when 'ka'
        board.p_22 = Piece::NONE
      when 'two'
        board.p_82 = board.p_22 = Piece::NONE
      when 'four'
        board.p_82 = board.p_22 = Piece::NONE
        board.p_11 = board.p_91 = Piece::NONE
      when 'six'
        board.p_82 = board.p_22 = Piece::NONE
        board.p_11 = board.p_91 = Piece::NONE
        board.p_21 = board.p_81 = Piece::NONE
      when 'eight'
        board.p_82 = board.p_22 = Piece::NONE
        board.p_11 = board.p_91 = Piece::NONE
        board.p_21 = board.p_81 = Piece::NONE
        board.p_31 = board.p_71 = Piece::NONE
      when 'ten'
        board.p_82 = board.p_22 = Piece::NONE
        board.p_11 = board.p_91 = Piece::NONE
        board.p_21 = board.p_81 = Piece::NONE
        board.p_31 = board.p_71 = Piece::NONE
        board.p_41 = board.p_61 = Piece::NONE
      end
    end
    self.boards << board
    save
  end

  def deliver_created_notices
    create_facebook_created_feed
    create_facebook_created_notification
  end

  def handicapped?
    HANDICAPS.include? self.handicap
  end

  def give_up!(user)
    if user == self.sente_user
      self.won_user = self.gote_user
      self.lost_user = self.sente_user
    else
      self.lost_user = self.gote_user
      self.won_user = self.sente_user
    end
    self.finished_at = Time.now
    self.playing = false
    self.given_up = true
    save
  end

  def make_board_from_movement(movement)
    number = self.boards.count
    board = self.boards.last.dup
    board.number = number
    board.apply_movement(movement)
    self.boards << board
    self.movements << movement
    self.number = number
    board
  end

  def make_board_from_movement!(movement)
    board = make_board_from_movement(movement)
    board.save && self.save
  end

  def of_user?(user)
    if user
      self.sente_user_id == user.id || self.gote_user_id == user.id
    else
      false
    end
  end

  def opponent(user = nil)
    user = self.author unless user
    if user
      if self.sente_user_id == user.id
        return self.gote_user
      else
        return self.sente_user
      end
    end
    nil
  end

  def set_players_from_order_and_handicap(proponent, opponent, order, handicap)
    if handicap =~ /(\w+)_(\w+)$/
      handicap_side = $1
      self.handicap = $2
    else
      handicap_side = nil
    end
    if handicap_side == 'proponent'
      sente = false
    elsif handicap_side == 'opponent'
      sente = true
    else
      case order
      when 'sente'
        sente = true
      when 'gote'
        sente = false
      else
        sente = [true, false].sample
      end
    end
    if sente
      self.sente_user = proponent
      self.gote_user = opponent
    else
      self.sente_user = opponent
      self.gote_user = proponent
    end
    nil
  end

  def users
    result = []
    result << self.sente_user if self.sente_user
    result << self.gote_user if self.gote_user
    result
  end

  class << self
    def finished
      criteria.where(:finished_at.lte => Time.now)
    end

    def of_user(user)
      criteria.any_of({ sente_user_id: user.id }, { gote_user_id: user.id })
    end

    def of_not_user(user)
      criteria.where(:sente_user_id.ne => user.id, :gote_user_id.ne => user.id)
    end

    def of_user_friends(user)
      ids = user.friend_ids
      criteria.any_of({ :sente_user_id.in => ids }, { :gote_user_id.in => ids })
    end

    def perform(game_id, method_name, *arguments)
      game = find(game_id)
      game.public_send(method_name, *arguments)
    end

    def playing
      criteria.where(playing: true)
    end

    def unnoticed(user)
      criteria.where(:user_noticed_ids.nin => [user._id])
    end
  end

private
  def destroy_boards
    self.boards.destroy_all
  end
end
