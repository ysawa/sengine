# -*- coding: utf-8 -*-

class FeedbackDecorator < ApplicationDecorator
  decorates :feedback

  def author_image
    if user_admin? && model.author
      UserDecorator.new(model.author).image
    else
      h.image_tag "noimage.gif", class: :face
    end
  end

  def content(pretty = true, length = nil)
    text = model.content || ''
    if length
      text = h.truncate(text, length: length)
    end
    if pretty
      prettify text
    else
      text
    end
  end

  def published
    if model.published
      '○'
    else
      '×'
    end
  end
end
