# -*- coding: utf-8 -*-

module Visibility::Published

  def publish
    self.published = true
    self.published_at ||= Time.now
  end

  def publish!
    publish
    save
  end

  def published?
    self.published && (self.published_at && self.published_at <= Time.now)
  end

  def unpublish
    self.published = false
  end

  def unpublish!
    unpublish
    save
  end

  def unpublished?
    !published
  end

  def self.included(klass)
    klass.field :published, type: Boolean, default: false
    klass.field :published_at, type: Time

    klass.class_eval <<-EOS
      class << self
        def published
          criteria.where(published: true, :published_at.lte => Time.now)
        end

        def unpublished
          or_conditions = []
          or_conditions << { :published.ne => true }
          or_conditions << { published: true, :published_at.gt => Time.now }
          criteria.where(:$and => [{ :$or => or_conditions }])
        end
      end
    EOS
  end
end
