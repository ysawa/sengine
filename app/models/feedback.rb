# -*- coding: utf-8 -*-

class Feedback
  include Mongoid::Document
  include Mongoid::Timestamps
  field :content, type: String
  field :dislike_user_ids, type: Array, default: []
  field :like_user_ids, type: Array, default: []
  field :published, type: Boolean, default: true
  belongs_to :author, class_name: 'User'
  has_many :children, class_name: 'Feedback', inverse_of: :parent
  belongs_to :parent, class_name: 'Feedback', inverse_of: :children

  def checked?(user)
    result = self.like_user_ids.include?(user.id)
    result ||= self.dislike_user_ids.include?(user.id)
    result
  end

  def dislike!(user)
    self.dislike_user_ids << (user.id)
    self.dislike_user_ids.uniq!
    self.like_user_ids.delete user.id
    save
  end

  def like!(user)
    self.like_user_ids << (user.id)
    self.like_user_ids.uniq!
    self.dislike_user_ids.delete user.id
    save
  end

  def publish!
    self.published = true
    save
  end

  def unpublish!
    self.published = false
    save
  end

  class << self
    def parents
      criteria.where(parent_id: nil)
    end

    def published
      criteria.where(published: true)
    end
  end
end
