# -*- coding: utf-8 -*-

class MovementDecorator < ApplicationDecorator
  delegate_all

  def kifu_format(past = nil)
    result = ''
    if model.sente?
      result += '▲'
    else
      result += '△'
    end
    # if model.move?
    #   result += point_to_full(model.from_point)
    # end
    if past && past.to_point == model.to_point
      result += '同'
    else
      result += point_to_full(model.to_point)
    end
    result += piece_to_kanji(model.role)
    if model.put?
      result += '打'
    elsif model.reverse?
      result += '成'
    end
    result
  end

protected

  def piece_to_kanji(piece)
    h.convert_piece_role_to_kanji(piece)
  end

  def point_to_full(point)
    x, y = point.to_a
    "#{h.convert_number_to_full x}#{h.convert_number_to_kanji y}"
  end
end
