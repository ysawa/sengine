# -*- coding: utf-8 -*-

class FeedbackDecorator < ApplicationDecorator
  decorates :feedback

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
end
