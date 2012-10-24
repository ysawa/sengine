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

  def name(link = false, user_link = false)
    sente_decorator = UserDecorator.new(game.sente_user)
    gote_decorator = UserDecorator.new(game.gote_user)
    sente = sente_decorator.name(user_link)
    gote = gote_decorator.name(user_link)
    game_name = I18n.t('game.battle_vs', sente: sente, gote: gote)
    if link
      h.link_to game_name.html_safe, model
    else
      game_name.html_safe
    end
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
