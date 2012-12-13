# -*- coding: utf-8 -*-

class Tag
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String, localize: true
  field :code, type: String
  field :content, type: String, localize: true
  validates_presence_of :code
  validates_uniqueness_of :code, case_sensitive: false

  def to_param
    if self.code?
      self.code
    else
      self.id
    end
  end

  class << self
    def find_with_code(code)
      criteria.where(code: code).first
    end
  end
end
