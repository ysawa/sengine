# -*- coding: utf-8 -*-

class PieceDecorator < ApplicationDecorator
  decorates :piece

  attr_accessor :reverse

  def direction
    model.sente? ? 'sente' : 'gote'
  end

  def html_classes
    [(model.sente? && !@reverse) || (!model.sente? && @reverse) ? 'upward' : 'downward']
  end
end
