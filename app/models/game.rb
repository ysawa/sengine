class Game
  include Mongoid::Document
  include Mongoid::Timestamps
  has_many :boards
  has_many :movements
  before_destroy :destroy_boards

private
  def destroy_boards
    self.boards.destroy_all
  end
end
