# -*- coding: utf-8 -*-

class UserDecorator < ApplicationDecorator
  delegate_all

  def admin
    if model.admin
      '○'
    else
      '×'
    end
  end

  def audio_on
    I18n.t("user.audio")[model.audio_on?]
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

  def face(image_link = false, image_options = {})
    content = image(image_link, image_options)
    if model.online?
      content += h.content_tag :aside, online, class: :online
    end
    h.content_tag :section, content, class: :face
  end

  def facebook_url
    if model.facebook_username
      "https://www.facebook.com/#{model.facebook_username}"
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

  def image(link = false, image_options = {})
    title = model.name
    image_options = image_options.stringify_keys
    image_options.reverse_merge!('alt' => title, 'title' => title, 'class' => :face)
    if model.facebook_id
      if image_options['class'].to_s =~ /large/
        size_params = 'width=100&height=100'
      else
        size_params = 'type=square'
      end
      image_url = "http://graph.facebook.com/#{model.facebook_id}/picture?#{size_params}"
    else
      image_url = "noimage.gif"
    end
    result = h.image_tag image_url, image_options
    case link
    when true
      h.link_to result, h.profile_path(model.id)
    when :facebook
      h.link_to result, "http://www.facebook.com/#{model.facebook_username}"
    when String, Hash
      h.link_to result, link
    else
      result
    end
  end

  def locale
    if model.locale
      result = model.locale.sub(/_.*$/, '')
      I18n.t('model.locales')[result.to_sym]
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

  def name_with_grade
    "#{name} #{grade}"
  end

  def online
    I18n.t("model.online")[model.online?]
  end

  def score
    if model.score
      h.number_with_delimiter model.score
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

  def won_games_count
    model.won_games.count
  end
end
