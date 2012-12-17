# -*- coding: utf-8 -*-

class Tag
  include Mongoid::Document
  include Mongoid::Timestamps
  field :code, type: String
  field :content, type: String, localize: true
  field :name, type: String, localize: true
  index({ code: 1 }, { unique: true, name: 'code_index' })
  validates_presence_of :code
  validates_uniqueness_of :code, case_sensitive: false

  def code=(string)
    result = string.tr(' 　', '_')
    result = result.gsub(/[!-\/\\:-@\[-`{-~}]/, "_")
    write_attribute(:code, result)
  end

  def to_param
    self.code
  end

  class << self
    def find_by_code(code)
      criteria.find_by(code: code)
    end

    def search(q)
      keywords = q.split(/[\s!-\/\\:-@\[-`{-~}　]/)
      if keywords.blank?
        return criteria
      end
      regs = keywords.collect { |keyword| Regexp.new(keyword, Regexp::IGNORECASE) }
      queries = []
      Sengine::LOCALES.each do |locale|
        queries << { :"name.#{locale}".in => regs }
      end
      criteria.any_of(queries)
    end
  end
end
