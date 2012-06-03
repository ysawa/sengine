# -*- coding: utf-8 -*-

class PieceDecorator < ApplicationDecorator
  decorates :piece

  attr_accessor :reverse

  def direction
    model.sente? ? 'sente' : 'gote'
  end

  def html_class(options = {})
    options.stringify_keys!
    klasses = []
    klasses << ((model.sente? && !@reverse) || (!model.sente? && @reverse) ? 'upward' : 'downward')
    klasses << 'moved' if options['moved']
    klasses << 'playable' if options['play']
    klasses
  end
end
