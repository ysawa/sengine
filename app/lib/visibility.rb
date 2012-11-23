# -*- coding: utf-8 -*-

module Visibility
  autoload :Shown, 'visibility/shown'
  autoload :Visible, 'visibility/visible'
  autoload :Pubished, 'visibility/pubished'

  def get_user_id(user)
    if user === User
      user_id = user.id
    else
      user_id = user
    end
  end
  module_function :get_user_id
end
