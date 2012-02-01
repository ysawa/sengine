class Piece
  include Mongoid::Document
  ROLES = %w(fu gyoku kin gin keima kyosha kaku hisha)
  field :sente, type: Boolean
  field :in_hand, type: Boolean
  field :role, type: String
  field :point, type: Point
  embedded_in :board

  def gote?
    !sente?
  end

  class << self
    def place(role, point, sente)
      new(role: role, point: point, sente: sente, in_hand: false)
    end
  end
end
