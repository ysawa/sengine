class Game
  include Mongoid::Document
  include Mongoid::Timestamps
  has_many :boards
  has_many :movements
  belongs_to :sente_user, class_name: 'User'
  belongs_to :gote_user, class_name: 'User'
  before_destroy :destroy_boards

private
  def destroy_boards
    self.boards.destroy_all
  end
end
