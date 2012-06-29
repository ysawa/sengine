# -*- coding: utf-8 -*-

module PiecesHelper
  KANJI_MAP = {
    fu: '歩',
    ky: '香',
    ke: '桂',
    gi: '銀',
    ki: '金',
    ka: '角',
    hi: '飛',
    ou: '玉',
    to: 'と',
    ny: '成香',
    nk: '成桂',
    ng: '成銀',
    um: '馬',
    ry: '竜'
  }

  def convert_piece_role_to_kanji(role)
    KANJI_MAP[Piece.stringify_role(role).to_sym]
  end


  def translate_piece_role(role)
    I18n.t('piece.roles')[Piece.stringify_role(role).to_sym]
  end
end
