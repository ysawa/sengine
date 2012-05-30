# -*- coding: utf-8 -*-

class UserDecorator < ApplicationDecorator
  decorates :user

  def image
    if model.facebook_id
      h.image_tag "http://graph.facebook.com/#{model.facebook_id}/picture?type=square", alt: model.name
    end
  end

  def name
    if model.email
      model.email.sub(/@.*$/, '')
    end
  end
end
