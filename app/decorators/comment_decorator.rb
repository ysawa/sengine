# -*- coding: utf-8 -*-

class CommentDecorator < ApplicationDecorator
  decorates :comment

  def author_image(link = false)
    if model.author
      UserDecorator.new(model.author).image(link)
    else
      h.image_tag "noimage.gif", class: :face
    end
  end

  def content
    if model.content
      prettify model.content
    end
  end
end
