# -*- coding: utf-8 -*-

class FeedbackDecorator < ApplicationDecorator
  delegate_all

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

  def dislike_number
    model.dislike_user_ids.size
  end

  def like_number
    model.like_user_ids.size
  end

  def published
    if model.published
      '○'
    else
      '×'
    end
  end

  def success
    if model.success
      '○'
    else
      '×'
    end
  end
end
