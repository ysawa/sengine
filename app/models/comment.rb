# -*- coding: utf-8 -*-

class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  field :content, type: String
  belongs_to :author, class_name: 'User'
  belongs_to :game
  before_save :strip_tail_line_feeds

  def strip_tail_line_feeds
    if self.content?
      self.content = self.content.sub(/(\r\n|\r|\n)+\z/,'')
    end
  end

  class << self
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
  end
end
