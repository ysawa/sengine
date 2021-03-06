# -*- coding: utf-8 -*-

class Tag
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  SYMBOL_REGEXP = /[\s!-\/\\:-@\[-`{-~}"'　]/
  field :code, type: String
  field :content, type: String, localize: true
  field :name, type: String, localize: true
  index({ code: 1 }, { unique: true, name: 'code_index' })
  belongs_to :author, inverse_of: 'authored_tags', class_name: 'User'
  mount_uploader :image, ImageUploader
  attr_protected :author_id
  validates_presence_of :code
  validates_uniqueness_of :code, case_sensitive: false

  def code=(string)
    if string.nil?
      return write_attribute(:code, nil)
    end
    result = string.tr(' 　', '_')
    result = result.gsub(SYMBOL_REGEXP, "_")
    result = result.downcase
    write_attribute(:code, result)
  end

  def generate_code_from_name
    return if code?
    write_attribute(:code, nil)
    Sengine::LOCALE_STRINGS.each do |locale|
      name_of_locale = self.name_translations[locale]
      if name_of_locale.present?
        self.code = name_of_locale
        break
      end
    end
    while self.code
      break if Tag.where(code: self.code).count == 0
      self.code += '_'
    end
    nil
  end

  def taggables(klass)
    klass.where(:tag_ids => self.id)
  end

  def to_param
    self.code
  end

  class << self
    def find_by_code(code)
      criteria.find_by(code: code)
    end

    def search(q)
      keywords = q.split(SYMBOL_REGEXP)
      if keywords.blank?
        return criteria
      end
      regs = keywords.collect { |keyword| Regexp.new(keyword, Regexp::IGNORECASE) }
      queries = []
      Sengine::LOCALE_STRINGS.each do |locale|
        queries << { :"name.#{locale}".in => regs }
      end
      criteria.any_of(queries)
    end
  end
end
