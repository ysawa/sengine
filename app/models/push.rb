# -*- coding: utf-8 -*-

class Push
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Visibility::Shown

  field :content, type: String
  field :push_type, type: String
  belongs_to :creator, class_name: 'User', inverse_of: :created_pushes
  belongs_to :pushable, polymorphic: true
  before_save :make_push_type

  PUSH_TYPES = %w(movement notice)

  def href
    case self.pushable
    when Movement
      game_id = self.pushable.game && self.pushable.game.id
      "/games/#{game_id}" if game_id
    when User
      user_id = self.pushable.id
      "/profile/#{user_id}"
    when Game
      game_id = self.pushable.id
      "/games/#{game_id}" if game_id
    else
      nil
    end
  end

  def make_push_type
    case self.pushable
    when Movement
      self.push_type = 'movement'
    else
      self.push_type = nil
    end
  end

  class << self
    def creator(creator)
      criteria.where(creator_id: creator.id)
    end
  end
end
