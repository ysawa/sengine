# -*- coding: utf-8 -*-

module Visibility
  autoload :Shown, 'visibility/shown'
  autoload :Visible, 'visibility/visible'
  autoload :Published, 'visibility/published'

  def get_user_id(user)
    case user
    when User
      user.id
    when String
      Moped::BSON::ObjectId(user)
    else
      user
    end
  end
  module_function :get_user_id
end
