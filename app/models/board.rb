class Board
  include Mongoid::Document
  include Mongoid::Timestamps
  field :black, type: Boolean
  field :number, type: Integer
  belongs_to :game
  has_one :movement
  has_many :pieces
end
