class Game
  include Mongoid::Document
  include Mongoid::Timestamps
  has_many :movements
  has_many :boards
end
