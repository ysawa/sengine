# -*- coding: utf-8 -*-

module ApplicationHelper

  def link_to_sign_in(name = nil, options = {})
    name ||= t('actions.sign_in_and_start')
    if Rails.env.production?
      link_to name, user_omniauth_authorize_path(:facebook), options
    else
      link_to name, new_user_session_path, options
    end
  end

  def page_name(controller_path, action_name)
    controller_name = controller_path.gsub('/', '.')
    I18n.t("pages.controllers.#{controller_name}.#{action_name}")
  end

  def site_title(subtitle = nil)
    elements = []
    case subtitle
    when nil
    when String
      elements << subtitle
    when Game
      game = subtitle
      if game.persisted?
        vs = []
        if game.sente_user
          vs << game.sente_user.name
        end
        vs << 'vs'
        if game.gote_user
          vs << game.gote_user.name
        end
        elements << vs.join(' ')
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
    else
      elements << subtitle.to_s
    end
    if Rails.env.production?
      elements << I18n.t('site.title')
    else
      elements << 'Demo'
    end
    elements.join(' | ')
  end
end
