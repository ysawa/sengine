# -*- coding: utf-8 -*-

class Point
  include Mongoid::Fields::Serializable

  def deserialize(object)
    if object.present?
      [ object["x"], object["y"] ]
    else
      nil
    end
  end

  def serialize(object)
    if object.present?
      { "x" => object[0], "y" => object[1] }
    else
      nil
    end
  end
end
