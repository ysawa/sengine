# -*- coding: utf-8 -*-

class PieceDecorator < ApplicationDecorator
  decorates :piece

  attr_accessor :reverse

  def direction
    model.sente? ? 'sente' : 'gote'
  end

  def html_class(options = {})
    options.stringify_keys!
    klasses = ['piece']
    klasses << "role_#{model.stringify_role}"
    klasses << ((model.sente? && !@reverse) || (!model.sente? && @reverse) ? 'upward' : 'downward')
    klasses << 'moved' if options['moved']
    klasses << 'playable' if options['play']
    klasses
  end

  def tagify(play, movement = nil)
    moved = h.piece_moved(model, movement)
    name = h.convert_piece_role_to_kanji model.role
    h.content_tag :div, name, role: model.stringify_role, direction: direction, class: html_class(play: play, moved: moved)
  end
end
