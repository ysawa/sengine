# -*- coding: utf-8 -*-

class Feedback
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Visibility::Published
  field :content, type: String
  field :dislike_user_ids, type: Array, default: []
  field :like_user_ids, type: Array, default: []
  field :success, type: Boolean, default: false
  belongs_to :author, class_name: 'User'
  has_many :children, class_name: 'Feedback', inverse_of: :parent
  belongs_to :parent, class_name: 'Feedback', inverse_of: :children
  attr_protected :dislike_user_ids, :like_user_ids, :success, :author_id, :parent_id
  before_save :strip_tail_line_feeds

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

  def strip_tail_line_feeds
    if self.content?
      self.content = self.content.sub(/(\r\n|\r|\n)+\z/,'')
    end
  end

  def success!
    self.success = true
    save
  end

  def unsuccess!
    self.success = false
    save
  end

  class << self
    def parents
      criteria.where(parent_id: nil)
    end

    def success
      criteria.where(success: true)
    end

    def unsuccess
      criteria.where(:success.ne => true)
    end
  end
end
