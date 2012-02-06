# -*- coding: utf-8 -*-

module PiecesHelper
  def convert_role_to_kanji(role)
    I18n.t('piece.roles')[role.to_sym]
  end
end
