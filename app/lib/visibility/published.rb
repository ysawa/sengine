# -*- coding: utf-8 -*-

module Visibility::Published

  def published?
    !unpublished?
  end

  def unpublished?
    self.published_at && self.published_at <= Time.now
  end

  def self.included(klass)
    klass.field :published_at, type: Time

    klass.class_eval <<-EOS
      class << self
        def published
          criteria.where(:published_at.ne => nil)
        end

        def unpublished
          criteria.where(:published.ne => true)
        end
      end
    EOS
  end
end
