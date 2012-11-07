# -*- coding: utf-8 -*-

module Visibility

  def black_user?(user)
    use_black_list? && self.black_user_ids.include?(user.id)
  end

  def invisible?(user)
    !visible?(user)
  end

  def visible?(user)
    result = published?
    result &&= white_user?(user)
    result &&= !black_user?(user)
    result
  end

  def white_user?(user)
    !use_white_list? || self.white_user_ids.include?(user.id)
  end

  def self.included(klass)
    klass.field :black_user_ids, type: Array, default: []
    klass.field :hidden_user_ids, type: Array, default: []
    klass.field :published_at, type: Time
    klass.field :use_black_list, type: Boolean, default: false
    klass.field :use_white_list, type: Boolean, default: false
    klass.field :white_user_ids, type: Array, default: []

    klass.class_eval <<-EOS
      class << self
        def hidden(user)
          criteria.where(:hidden_user_ids.in => user.id)
        end

        def published
          criteria.where(published_at.ne => nil)
        end

        def shown(user)
          criteria.where(:hidden_user_ids.nin => user.id)
        end

        def unpublished
          criteria.where(:published.ne => true)
        end

        def visible(user)
          user_id = user.id
          or_conditions = []
          or_conditions << { :use_black_list.ne => true, :use_white_list.ne => true }
          or_conditions << { :use_black_list => true, :black_user_ids.nin => [user_id] }
          or_conditions << { :use_white_list => true, :white_user_ids.in => [user_id] }
          published.where(:$and => [{ :$or => or_conditions }])
        end
      end
    EOS
  end
end
