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
