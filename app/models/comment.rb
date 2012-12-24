# -*- coding: utf-8 -*-

class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  field :content, type: String
  belongs_to :author, class_name: 'User'
  belongs_to :commentable, polymorphic: true
  before_save :strip_tail_line_feeds
  validates_presence_of :content

  def strip_tail_line_feeds
    if self.content?
      self.content = self.content.sub(/(\r\n|\r|\n)+\z/,'')
    end
  end

  class << self
    def not_author(user)
      criteria.where(:author_id.ne => user.id)
    end

    def of_author_friends(user)
      ids = user.friend_ids
      criteria.where(:author_id.in => ids)
    end

    def of_game(game)
      case game
      when Array
        game_ids = game.collect do |g|
          if g.is_a? Game
            g.id
          else
            Moped::BSON::ObjectId(g)
          end
        end
        criteria.where(:commentable_id.in => game_ids, commentable_type: 'Game')
      when Moped::BSON::ObjectId, String
        criteria.where(commentable_id: Moped::BSON::ObjectId(game), commentable_type: 'Game')
      else
        criteria.where(commentable_id: game.id, commentable_type: 'Game')
      end
    end
  end
end
