# -*- coding: utf-8 -*-

module Tagging

  def delete_blank_tag_ids
    result = []
    self.tag_ids.each do |tag_id|
      next if tag_id.blank?
      result << tag_id
    end
    self.tag_ids = result
  end

  def make_sure_unique_tag_ids
    self.tag_ids = self.tag_ids.uniq
  end

  def tags
    Tag.where(:id.in => self.tag_ids)
  end

  def tag_append(tag)
    tag_id = Tagging.get_tag_id(tag)
    self.tag_ids << tag_id
  end

  def self.included(klass)
    klass.field :tag_ids, type: Array, default: []
    klass.before_save :delete_blank_tag_ids
    klass.before_save :make_sure_unique_tag_ids

    klass.class_eval <<-EOS
      class << self
        def find_by_tag(tag)
          tag_id = Tagging.get_tag_id(tag)
          criteria.where(:tag_ids.in => [tag_id])
        end
      end
    EOS
  end

  def self.get_tag_id(tag)
    case tag
    when Tag
      tag_id = tag.id
    when String
      tag_id = Moped::BSON::ObjectId(tag)
    else
      tag_id = tag
    end
    tag_id
  end
end
