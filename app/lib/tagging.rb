# -*- coding: utf-8 -*-

module Tagging

  def make_tag_ids_legal
    ids = self.tag_ids.select { |id| Moped::BSON::ObjectId.legal?(id) }
    self.tag_ids = ids.collect { |id| Moped::BSON::ObjectId(id) }
  end

  def make_tag_ids_unique
    self.tag_ids = self.tag_ids.uniq
  end

  def tags
    Tag.where(:id.in => self.tag_ids)
  end

  def tag_append(tag)
    tag_id = Tagging.format_tag_id(tag)
    self.tag_ids << tag_id
  end

  def tag_delete(tag)
    tag_id = Tagging.format_tag_id(tag)
    self.tag_ids.delete tag_id
  end

  def tag_name_append(tag_name)
    tag = Tag.find_or_initialize_by(name: tag_name)
    unless tag.persisted?
      tag.generate_code_from_name
      tag.save
    end
    self.tag_ids << tag.id
  end

  def tag_related_objects
    self.class.where(:tag_ids.in => self.tag_ids, :_id.ne => self.id)
  end

  def self.format_tag_id(tag)
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

  def self.included(klass)
    klass.field :tag_ids, type: Array, default: []
    klass.attr_protected :tag_ids
    klass.before_save :make_tag_ids_legal
    klass.before_save :make_tag_ids_unique

    klass.class_eval <<-EOS
      class << self
        def find_by_tag(tag)
          tag_id = Tagging.format_tag_id(tag)
          criteria.where(:tag_ids.in => [tag_id])
        end

        def search(q)
          tag_ids = Tag.search(q).collect { |tag| tag.id }
          criteria.where(:tag_ids.all => tag_ids)
        end
      end
    EOS
  end
end
