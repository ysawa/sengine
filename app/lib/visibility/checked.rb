# -*- coding: utf-8 -*-

module Visibility::Checked

  def checked?(user)
    user_id = Visibility.get_user_id user
    self.checked_user_ids.include? user_id
  end

  def checked_users
    User.where(:_id.in => self.checked_user_ids)
  end

  def check_user(user)
    user_id = Visibility.get_user_id user
    self.checked_user_ids << user_id
    self.checked_user_ids.uniq!
  end

  def check_user!(user)
    check_user(user)
    save
  end

  def unchecked?(user)
    !checked?(user)
  end

  def self.included(klass)
    klass.field :checked_user_ids, type: Array, default: []

    klass.class_eval <<-EOS
      class << self
        def checked(user)
          user_id = Visibility.get_user_id user
          criteria.where(:checked_user_ids => user_id)
        end

        def unchecked(user)
          user_id = Visibility.get_user_id user
          criteria.where(:checked_user_ids.ne => user_id)
        end
      end
    EOS
  end
end
