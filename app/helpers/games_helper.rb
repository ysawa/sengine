# -*- coding: utf-8 -*-

module GamesHelper
  FULLSUJIS = %w(０ １ ２ ３ ４ ５ ６ ７ ８ ９)
  KANSUJIS = %w(零 一 二 三 四 五 六 七 八 九)
  HANDICAPS = %w(proponent_hi proponent_ka proponent_two proponent_four
                 proponent_six proponent_eight proponent_ten
                 opponent_hi opponent_ka opponent_two opponent_four
                 opponent_six opponent_eight opponent_ten)

  def game_handicaps_for_select
    ::GamesHelper::HANDICAPS.collect do |handicap|
      name = I18n.t("game.handicaps.#{handicap}")
      [name, handicap]
    end
  end

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

  def convert_number_to_full(number)
    ::GamesHelper::FULLSUJIS[number]
  end

  def convert_number_to_kanji(number)
    ::GamesHelper::KANSUJIS[number]
  end

  def human_theme_name(theme)
    I18n.t('game.themes')[theme.to_sym] if theme
  end
end
