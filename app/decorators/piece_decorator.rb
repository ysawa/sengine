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
    klasses << "piece_#{model.role}"
    klasses << ((model.sente? && !@reverse) || (!model.sente? && @reverse) ? 'upward' : 'downward')
    klasses << 'moved' if options['moved']
    klasses << 'playable' if options['play']
    klasses
  end

  def tagify(play, movement = nil)
    if movement && movement.to_point == model.point
      moved = true
    else
      moved = false
    end
    name = h.convert_piece_role_to_kanji model.role
    h.content_tag :div, name, id: model.id, role: model.role, direction: direction, class: html_class(play: play, moved: moved)
  end
end
