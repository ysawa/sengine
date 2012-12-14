# -*- coding: utf-8 -*-

module Tagging

  def make_sure_unique_tags
    self.tag_ids = self.tag_ids.uniq
  end

  def tags
    Tag.where(:id.in => self.tag_ids)
  end

  def self.included(klass)
    klass.field :tag_ids, type: Array, default: []
    klass.before_save :make_sure_unique_tags

    klass.class_eval <<-EOS
      class << self
        def find_by_tag(tag)
          case tag
          when Tag
            tag_id = tag.id
          else
            tag_id = tag
          end
          criteria.where(:tag_ids.in => [tag_id])
        end
      end
    EOS
  end
end
