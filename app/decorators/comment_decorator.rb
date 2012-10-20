# -*- coding: utf-8 -*-

class CommentDecorator < Draper::Base
  decorates :comment

  def content
  end

  def user_image
    if user_admin? && model.user
      UserDecorator.new(model.user).image
    else
      h.image_tag "noimage.gif", class: :face
    end
  end
end
