# -*- coding: utf-8 -*-

class Push
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Visibility::Shown

  field :content, type: String
  field :push_type, type: String
  belongs_to :creator, class_name: 'User', inverse_of: :created_pushes

  class << self
    def creator(creator)
      criteria.where(creator_id: creator.id)
    end
  end
end
