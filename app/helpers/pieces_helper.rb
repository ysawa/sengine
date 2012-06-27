# -*- coding: utf-8 -*-

module PiecesHelper
  def convert_piece_role_to_kanji(role)
    I18n.t('piece.roles')[Piece.stringify_role(role)]
  end

  def piece_moved(piece, movement)
    movement && (movement.to_point == piece.point)
  end
end
