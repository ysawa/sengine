# -*- coding: utf-8 -*-

class TagDecorator < ApplicationDecorator
  decorates :tag

  def content(locale = nil)
    target_locale = get_locale(locale)
    result = model.content_translations[target_locale]
    if result
      prettify result
    end
  end

  def name(link = false, locale = nil)
    target_locale = get_locale(locale)
    result = model.name_translations[target_locale]
    if result
      if link
        h.link_to result, model
      else
        result
      end
    end
  end

private

  def get_locale(locale)
    case locale
    when String
      locale
    when Symbol
      locale.to_s
    else
      I18n.locale.to_s
    end
  end
end
