# -*- coding: utf-8 -*-

class Tag
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String, localize: true
  field :code, type: String
  field :content, type: String, localize: true

  def to_param
    if self.code?
      self.code
    else
      self.id
    end
  end

  class << self
    def find_with_code(code)
    end
  end
end
