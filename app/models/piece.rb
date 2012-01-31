class Piece
  include Mongoid::Document
  ROLES = %w(fu gyoku kin gin keima kyosha kaku hisha)
  field :black, type: Boolean
  field :in_hand, type: Boolean
  field :role, type: String
  field :point, type: Point
  embedded_in :board

  def white?
    !black?
  end

  class << self
    def place(role, point, black)
      new(role: role, point: point, black: black, in_hand: false)
    end
  end
end
