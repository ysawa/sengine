# -*- coding: utf-8 -*-

module Respect

  def follow(user)
    self.following_user_ids << user.id
  end

  def follow!(user)
    follow(user)
    save
  end

  def followed?(user)
    user.following_user_ids.include? self.id
  end

  def followed_users
    self.class.where(following_user_ids: self.id)
  end

  def following?(user)
    self.following_user_ids.include? user.id
  end

  def following_users
    self.class.where(:_id.in => self.following_user_ids)
  end

  def make_following_user_ids_legal
    self.following_user_ids = self.following_user_ids.select { |id| Moped::BSON::ObjectId.legal?(id) }
  end

  def make_following_user_ids_unique
    self.following_user_ids = self.following_user_ids.uniq
  end

  def unfollow(user)
    self.following_user_ids.delete user.id
  end

  def unfollow!(user)
    unfollow(user)
    save
  end

  def self.included(klass)
    klass.field :following_user_ids, type: Array, default: []
    klass.before_save :make_following_user_ids_unique
    klass.before_save :make_following_user_ids_legal
  end
end
