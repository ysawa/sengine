require 'spec_helper'

describe "Games" do

  describe "GET /games" do
    context 'if user signed in' do
      before :each do
        @current_user = Fabricate(:user)
      end

      it "works!" do
        user_sign_in_with_post(@current_user, 'PASSWORD')
        get games_path
        response.status.should be(200)
      end

      it 'the page can be accessed from mypage' do
        user_sign_in_with_visit(@current_user, 'PASSWORD')
        visit root_path
        click_link I18n.t('pages.controllers.games.index')
        page.should have_selector 'ul#games'
      end
    end

    context 'if user NOT signed in' do
      it "doesn't work." do
        get games_path
        response.status.should be(302)
      end
    end
  end

  describe "GET /games/1" do
    before :each do
      @sente_user = Fabricate(:user)
      @gote_user = Fabricate(:user)
      @game = Game.new
      @game.sente_user = @sente_user
      @game.gote_user = @gote_user
      @game.save
      @board = Board.hirate
      @board.game = @game
      @board.save
    end

    context 'if user signed in' do

      it "works!" do
        user_sign_in_with_post(@sente_user, 'PASSWORD')
        get game_path(@game)
        response.status.should be(200)
      end
    end

    context 'if user NOT signed in' do
      it "doesn't work." do
        get game_path(@game)
        response.status.should be(302)
      end
    end
  end
end
