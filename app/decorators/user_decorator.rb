# -*- coding: utf-8 -*-

class UserDecorator < ApplicationDecorator
  decorates :user

  def gender
    case model.gender
    when 'male'
      I18n.t("user.gender.male")
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

  def name
    if model.email
      model.email.sub(/@.*$/, '')
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
