# -*- coding: utf-8 -*-

class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  field :content, type: String
  belongs_to :author, class_name: 'User'
  belongs_to :game
end
