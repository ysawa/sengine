# -*- coding: utf-8 -*-

class TagDecorator < ApplicationDecorator
  decorates :tag

  def content
    if model.content
      prettify model.content
    end
  end

  def name(link = false)
    result = model.name
    if link
      h.link_to result, model
    else
      result
    end
  end
end
