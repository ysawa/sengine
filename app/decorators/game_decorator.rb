# -*- coding: utf-8 -*-

class GameDecorator < ApplicationDecorator
  decorates :game

  def facebook_comments_count
    url = h.game_url(model, protocol: 'http')
    "<fb:comments-count href=#{url}></fb:comments-count>".html_safe
  end

  def finished_at(options = {})
    time = model.read_attribute(:finished_at)
    localize_time(time, options)
  end

  def time_span
    if model.finished_at
      time = model.finished_at
    else
      time = Time.now
    end
    h.distance_of_time_in_words(time, model.created_at)
  end
end
