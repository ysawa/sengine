# -*- coding: utf-8 -*-

class Feedback
  include Mongoid::Document
  include Mongoid::Timestamps
  field :content, type: String
  field :published, type: Boolean, default: false
  belongs_to :author, class_name: 'User'
  has_many :children, class_name: 'Feedback', inverse_of: :parent
  belongs_to :parent, class_name: 'Feedback', inverse_of: :children

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
