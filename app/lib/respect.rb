# -*- coding: utf-8 -*-

module Respect

  def followed_users
    self.class.where(following_user_ids: self.id)
  end

  def following_users
    self.class.where(:_id.in => self.following_user_ids)
  end

  def self.included(klass)
    klass.field :following_user_ids, type: Array, default: []
  end
end
