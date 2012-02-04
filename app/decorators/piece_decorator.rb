class PieceDecorator < ApplicationDecorator
  decorates :piece

  def direction
    model.sente? ? 'sente' : 'gote'
  end

  def html_classes
    [model.sente? ? 'upward' : 'downward']
  end
end
