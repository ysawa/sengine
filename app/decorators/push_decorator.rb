# -*- coding: utf-8 -*-

class PushDecorator < ApplicationDecorator
  decorates :push

  def content(link = false)
    result = model.content
    if link
      h.link_to result, model.href
    else
      result
    end
  end
end
