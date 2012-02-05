# -*- coding: utf-8 -*-

module GamesHelper
  KANSUJIS = ['零', '一', '二', '三', '四', '五', '六', '七', '八', '九']
  def convert_number_to_kanji(number)
    KANSUJIS[number]
  end
end
