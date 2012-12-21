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

  def image(link = false, image_options = {})
    result = h.image_tag model.image.url, image_options
    if link
      h.link_to result, model
    else
      result
    end
  end

  def name(link = false, locale = nil)
    target_locale = get_locale(locale)
    result = model.name_translations[target_locale]
    if result.blank?
      model.name_translations.each do |key, value|
        if value.present?
          result = value
          break
        end
      end
      if result.blank?
        result = 'untitled'
      end
    end
    if link
      h.link_to result, model
    else
      result
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
