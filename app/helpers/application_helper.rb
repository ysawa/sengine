# -*- coding: utf-8 -*-

module ApplicationHelper

  def current_user_decorator
    return @current_user_decorator if @current_user_decorator
    if current_user
      @current_user_decorator = UserDecorator.new current_user
    end
  end

  def facebook_enabled?
    # Rails.env.production?
    Sengine.system.facebook[:enabled]
  end

  def link_to_sign_in(name = nil, options = {})
    name ||= t('actions.sign_in_and_start')
    # if Rails.env.production?
    #   link_to name, user_omniauth_authorize_path(:facebook), options
    # else
    #   link_to name, new_user_session_path, options
    # end
    link_to name, user_omniauth_authorize_path(:facebook), options
  end

  def page_name(controller_path, action_name)
    controller_name = controller_path.gsub('/', '.')
    I18n.t("pages.controllers.#{controller_name}.#{action_name}")
  end

  def site_title(subtitle = nil)
    elements = site_title_elements(subtitle)
    elements.join(' | ')
  end

  def site_title_elements(subtitle = nil)
    elements = []
    case subtitle
    when nil
    when String
      elements << subtitle
    when Game
      game = subtitle
      if game.persisted?
        if game.sente_user && game.gote_user
          sente = game.sente_user.name
          gote = game.gote_user.name
          elements << I18n.t('game.battle_vs', sente: sente, gote: gote)
        end
      else
        elements << I18n.t('pages.controllers.games.new')
      end
    when User
      user = subtitle
      if user.persisted?
        elements << user.name
      else
        elements << User.model_name.human
      end
    when Tag
      tag = subtitle
      if tag.persisted?
        elements << tag.name
      else
        elements << Tag.model_name.human
      end
    when Array
      elements = subtitle
    else
      elements << subtitle.to_s
    end
    elements << I18n.t('site.title')
    elements
  end
end
