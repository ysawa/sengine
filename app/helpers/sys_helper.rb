# -*- coding: utf-8 -*-

module SysHelper
  def sys_site_title(subtitle = nil)
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
      elements << 'Sys'
      elements << I18n.t('site.title')
    else
      elements << 'Sys'
    end
    elements.join(' | ')
  end
end
