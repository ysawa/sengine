# -*- coding: utf-8 -*-

module Respect

  def followed_users
    self.class.where(following_user_ids: self.id)
  end

  def following_users
    self.class.where(:_id.in => self.following_user_ids)
  end

  def make_following_user_ids_unique
    self.following_user_ids = self.following_user_ids.uniq
  end

  def self.included(klass)
    klass.field :following_user_ids, type: Array, default: []
    klass.before_save :make_following_user_ids_unique
  end
end
