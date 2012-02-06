# -*- coding: utf-8 -*-

class Movement
  include Mongoid::Document
  include Mongoid::Timestamps
  field :sente, type: Boolean
  field :from_point, type: Point
  field :move, type: Boolean
  field :number, type: Integer
  field :put, type: Boolean
  field :reverse, type: Boolean
  field :role, type: String
  field :to_point, type: Point
  belongs_to :board
  belongs_to :game
end
