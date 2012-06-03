# -*- coding: utf-8 -*-

class UserDecorator < ApplicationDecorator
  decorates :user

  def gender
    case model.gender
    when 'male'
      I18n.t("user.genders.male")
    when 'female'
      I18n.t("user.genders.female")
    else
    end
  end

  def image
    if model.facebook_id
      h.image_tag "http://graph.facebook.com/#{model.facebook_id}/picture?type=square", alt: model.name
    else
      h.image_tag "noimage.gif", alt: model.name
    end
  end

  def locale
    if model.locale
      result = model.locale.sub(/_.*$/, '')
      I18n.t('user.locales')[result.to_sym]
    end
  end

  def name(link = true)
    human_name = nil
    if model.name?
      human_name = model.name
    elsif model.email?
      human_name = model.email.sub(/@.*$/, '')
    end
    if link
      h.link_to human_name, h.profile_path(model.id)
    else
      human_name
    end
  end

  def timezone
    if model.timezone
      elements = ['GMT']
      if model.timezone >= 0
        elements << "+"
      else
        elements << "-"
      end
      elements << ("%02d:00" % model.timezone.abs)
      elements.join
    else
    end
  end
end
