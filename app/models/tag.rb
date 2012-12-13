# -*- coding: utf-8 -*-

class Tag
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String, localize: true
  field :code, type: String
  field :content, type: String, localize: true
  index({ code: 1 }, { unique: true, name: 'code_index' })
  validates_presence_of :code
  validates_uniqueness_of :code, case_sensitive: false

  def to_param
    self.code
  end

  class << self
    def find_by_code(code)
      criteria.find_by(code: code)
    end
  end
end
