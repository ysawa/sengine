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
      { "x" => object[0].to_i, "y" => object[1].to_i }
    else
      nil
    end
  end
end
