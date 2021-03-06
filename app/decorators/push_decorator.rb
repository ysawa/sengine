# -*- coding: utf-8 -*-

class PushDecorator < ApplicationDecorator
  delegate_all

  def content(link = false)
    result = model.content
    if link && model.href.present?
      h.link_to result, model.href
    else
      result
    end
  end
end
