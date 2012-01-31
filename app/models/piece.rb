class Piece
  include Mongoid::Document
  field :black, type: Boolean
  field :in_hand, type: Boolean
  field :role, type: String
  field :reversed, type: Boolean
  field :point, type: Point

  def white?
    !black?
  end
end
