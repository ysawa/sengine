# -*- coding: utf-8 -*-

class GameDecorator < ApplicationDecorator
  decorates :game

  def finished_at(options = {})
    time = model.read_attribute(:finished_at)
    localize_time(time, options)
  end
end
