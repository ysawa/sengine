# -*- coding: utf-8 -*-

class PieceDecorator < ApplicationDecorator
  delegate_all

  attr_accessor :reverse

  def html_class(options = {})
    options.stringify_keys!
    klasses = ['piece']
    klasses << "role_#{model.stringify_role}"
    klasses << ((model.sente? && !@reverse) || (!model.sente? && @reverse) ? 'upward' : 'downward')
    klasses << 'moved' if options['moved']
    klasses << 'playable' if options['play']
    klasses
  end

  def player
    model.sente? ? 'sente' : 'gote'
  end

  def tagify(play, moved = nil)
    name = h.convert_piece_role_to_kanji model.role
    title = h.translate_piece_role model.role
    h.content_tag :div, name, role: model.stringify_role, player: player, class: html_class(play: play, moved: moved), title: title
  end
end
