require 'spec_helper'

describe MovementDecorator do
  before :each do
    @movement = Fabricate(:movement)
    @decorator = MovementDecorator.new(@movement)
  end

  describe '.kifu_format' do
    it 'make kifu formatted string' do
      @decorator.kifu_format.should be_a String
    end
  end
end
