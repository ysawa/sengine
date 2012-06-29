# -*- coding: utf-8 -*-

class Hand
  include Mongoid::Fields::Serializable
  # Hand means the numbers of pieces in hands of players

  def deserialize(object)
    if object.present?
      [
        nil,
        object["fu"],
        object["ky"],
        object["ke"],
        object["gi"],
        object["ki"],
        object["ka"],
        object["hi"],
        object["ou"]
      ]
    else
      nil
    end
  end

  def serialize(object)
    if object.present?
      {
        "fu" => object[1].to_i,
        "ky" => object[2].to_i,
        "ke" => object[3].to_i,
        "gi" => object[4].to_i,
        "ki" => object[5].to_i,
        "ka" => object[6].to_i,
        "hi" => object[7].to_i,
        "ou" => object[8].to_i,
      }
    else
      nil
    end
  end
end
