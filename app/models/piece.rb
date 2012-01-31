class Piece
  include Mongoid::Document
  ROLES = %w(fu gyoku kin gin keima kyosha kaku hisya)
  field :black, type: Boolean
  field :in_hand, type: Boolean
  field :role, type: String
  field :point, type: Point
  belongs_to :boards

  def white?
    !black?
  end
end
