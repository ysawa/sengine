# -*- coding: utf-8 -*-

module GamesHelper
  KANSUJIS = ['零', '一', '二', '三', '四', '五', '六', '七', '八', '九']

  def make_theme_class_from_game(game)
    if game && game.theme
      "theme_#{game.theme}"
    else
      'theme_default'
    end
  end

  def game_theme_icon(theme, html_options = {})
    html_options = html_options.stringify_keys
    html_options.reverse_merge!(
      'class' => 'theme',
      'title' => human_theme_name(theme)
    )
    image_tag "themes/#{theme}.gif", html_options
  end

  def convert_number_to_kanji(number)
    KANSUJIS[number]
  end

  def human_theme_name(theme)
    I18n.t('game.themes')[theme.to_sym] if theme
  end
end
