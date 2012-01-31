class Movement
  include Mongoid::Document
  field :black, type: Boolean
  field :from_point, type: Point
  field :move, type: Boolean
  field :number, type: Integer
  field :put, type: Boolean
  field :reverse, type: Boolean
  field :role, type: String
  field :to_point, type: Point
end
