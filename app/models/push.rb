# -*- coding: utf-8 -*-

class Push
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :content, type: String
  field :push_type, type: String
  belongs_to :creator, class_name: 'User', inverse_of: :created_pushes
end
