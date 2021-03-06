# -*- coding: utf-8 -*-

module Visibility::Hidden

  def hidden?(user)
    user_id = Visibility.get_user_id user
    self.hidden_user_ids.include? user_id
  end

  def hidden_users
    User.where(:_id.in => self.hidden_user_ids)
  end

  def hide_user(user)
    user_id = Visibility.get_user_id user
    self.hidden_user_ids << user_id
    self.hidden_user_ids.uniq!
  end

  def hide_user!(user)
    hide_user(user)
    save
  end

  def shown?(user)
    !hidden?(user)
  end

  def self.included(klass)
    klass.field :hidden_user_ids, type: Array, default: []

    klass.class_eval <<-EOS
      class << self
        def hidden(user)
          user_id = Visibility.get_user_id user
          criteria.where(:hidden_user_ids => user_id)
        end

        def shown(user)
          user_id = Visibility.get_user_id user
          criteria.where(:hidden_user_ids.ne => user_id)
        end
      end
    EOS
  end
end
