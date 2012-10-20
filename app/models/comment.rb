# -*- coding: utf-8 -*-

class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  field :content, type: String
  belongs_to :user
end
