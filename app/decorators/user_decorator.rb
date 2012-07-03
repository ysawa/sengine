# -*- coding: utf-8 -*-

class UserDecorator < ApplicationDecorator
  decorates :user

  def admin
    if user.admin
      '○'
    else
      '×'
    end
  end

  def audio_on
    I18n.t("user.audio")[model.audio_on?]
  end

  def facebook_url
    if user.facebook_username
      "https://www.facebook.com/#{user.facebook_username}"
    else
      '#'
    end
  end

  def games_count
    model.sente_games.count + model.gote_games.count
  end

  def grade
    h.stringify_grade(model.grade)
  end

  def gender
    case model.gender
    when 'male'
      I18n.t("user.genders.male")
    when 'female'
      I18n.t("user.genders.female")
    else
    end
  end

  def image(link = false)
    title = model.name
    if model.facebook_id
      result = h.image_tag "http://graph.facebook.com/#{model.facebook_id}/picture?type=square", alt: title, title: title, class: :face
    else
      result = h.image_tag "noimage.gif", alt: title, title: title, class: :face
    end
    if link
      h.link_to result, h.profile_path(model.id)
    else
      result
    end
  end

  def locale
    if model.locale
      result = model.locale.sub(/_.*$/, '')
      I18n.t('user.locales')[result.to_sym]
    end
  end

  def lost_games_count
    model.lost_games.count
  end

  def name(link = false)
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

  def online
    I18n.t("user.online")[model.online?]
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

  def won_games_count
    model.won_games.count
  end
end
