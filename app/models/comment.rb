# -*- coding: utf-8 -*-

class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  field :content, type: String
  belongs_to :author, class_name: 'User'
  belongs_to :commentable, polymorphic: true
  before_save :strip_tail_line_feeds

  def strip_tail_line_feeds
    if self.content?
      self.content = self.content.sub(/(\r\n|\r|\n)+\z/,'')
    end
  end

  class << self
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
        criteria.where(:game_id.in => game_ids)
      when Moped::BSON::ObjectId, String
        criteria.where(game_id: Moped::BSON::ObjectId(game))
      else
        criteria.where(game_id: game.id)
      end
    end

    def of_not_author(user)
      criteria.where(:author_id.ne => user.id)
    end
  end
end
