# -*- coding: utf-8 -*-

class MovementDecorator < Draper::Base
  decorates :movement

  def kifu_format
    result = ''
    if movement.sente?
      result += '▲'
    else
      result += '△'
    end
    if movement.move?
      result += point_to_full(movement.from_point)
    end
    result += point_to_full(movement.to_point)
    result += piece_to_kanji(movement.role_value)
    if movement.put?
      result += '打'
    elsif movement.reverse?
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
