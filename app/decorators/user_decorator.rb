# -*- coding: utf-8 -*-

class UserDecorator < ApplicationDecorator
  decorates :user

  def name
    if model.email
      model.email.sub(/@.*$/, '')
    end
  end
end
