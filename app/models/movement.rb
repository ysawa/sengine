# -*- coding: utf-8 -*-

class Movement
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::MapReduce
  field :sente, type: Boolean
  field :from_point, type: Point
  field :move, type: Boolean
  field :number, type: Integer
  field :put, type: Boolean
  field :reverse, type: Boolean
  field :role, type: String
  field :role_value, type: Integer
  field :to_point, type: Point
  belongs_to :board
  belongs_to :game

  def gote?
    !sente?
  end

  def role=(string)
    if string.present?
      write_attribute(:role, string)
      write_attribute(:role_value, Piece::ROLE_STRINGS.index(string))
    else
      write_attribute(:role, nil)
      write_attribute(:role_value, nil)
    end
  end
end
