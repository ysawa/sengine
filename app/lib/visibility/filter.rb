# -*- coding: utf-8 -*-

module Visibility::Filter

  def black_user?(user)
    user_id = Visibility.get_user_id user
    using_black_list? && self.black_user_ids.include?(user_id)
  end

  def use_black_list
    self.using_black_list = true
  end

  def use_white_list
    self.using_white_list = true
  end

  def visible?(user)
    result = white_user?(user)
    result &&= !black_user?(user)
    result
  end

  def white_user?(user)
    user_id = Visibility.get_user_id user
    !using_white_list? || self.white_user_ids.include?(user_id)
  end

  def self.included(klass)
    klass.field :black_user_ids, type: Array, default: []
    klass.field :using_black_list, type: Boolean, default: false
    klass.field :using_white_list, type: Boolean, default: false
    klass.field :white_user_ids, type: Array, default: []
    klass.attr_protected :black_user_ids, :using_black_list, :using_white_list, :white_user_ids

    klass.class_eval <<-EOS
      class << self
        def visible(user)
          user_id = Visibility.get_user_id user
          or_conditions = []
          or_conditions << { :using_black_list.ne => true, :using_white_list.ne => true }
          or_conditions << { :using_black_list => true, :black_user_ids.ne => user_id }
          or_conditions << { :using_white_list => true, :white_user_ids => user_id }
          criteria.where(:$and => [{ :$or => or_conditions }])
        end
      end
    EOS
  end
end
