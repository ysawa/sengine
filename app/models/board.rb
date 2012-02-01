class Board
  include Mongoid::Document
  include Mongoid::Timestamps
  field :sente, type: Boolean
  field :number, type: Integer
  belongs_to :game
  has_one :movement
  embeds_many :pieces do
    def on_point(point)
      @target.select do |piece|
        if point == piece.point
          return piece
        end
      end
    end
  end

  def hirate
    write_attributes({ sente: false, number: 0 })
    piece_mirror('gyoku', [5, 9])
    piece_mirror('kin', [4, 9], true)
    piece_mirror('gin', [3, 9], true)
    piece_mirror('kei', [2, 9], true)
    piece_mirror('kyosha', [1, 9], true)
    piece_mirror('kaku', [8, 8])
    piece_mirror('hisha', [8, 2])
    1.upto(9).each do |x|
      piece_mirror('fu', [x, 7])
    end
    true
  end

  def piece_on_point(point)
    self.pieces.each do |piece|
      if point == piece.point
        return piece
      end
    end
    nil
  end

  class << self
    def hirate
      board = new
      board.hirate
      board
    end
  end

private
  def piece_mirror(role, point, double = false)
    x = point[0]
    y = point[1]
    self.pieces << Piece.place(role, [x, y], true)
    self.pieces << Piece.place(role, [(10 - x).abs, (10 - y).abs], false)
    if double
      self.pieces << Piece.place(role, [(10 - x).abs, y], true)
      self.pieces << Piece.place(role, [x, (10 - y).abs], false)
    end
  end
end
