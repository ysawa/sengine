require 'spec_helper'

describe GameDecorator do
  before :each do
    @game = Fabricate(:game)
    @board = Board.hirate
    @board.game = @game
    @board.save
    @decorator = GameDecorator.new(@game)
  end

  describe '.facebook_comments_count' do
    it 'generates a fb:comments-count tag' do
      html = @decorator.facebook_comments_count
      html.should include "<fb:comments-count"
    end
  end

  describe '.finished_at' do
    it 'generates a time string' do
      result = @decorator.finished_at
      result.should be_nil
      @game.finished_at = Time.now
      result = @decorator.finished_at
      result.should include Time.now.year.to_s
    end
  end
end
