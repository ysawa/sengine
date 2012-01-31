require 'spec_helper'

describe "games/index" do
  before(:each) do
    assign(:games, [
      stub_model(Game, created_at: Time.now),
      stub_model(Game, created_at: Time.now)
    ])
  end

  it "renders a list of games" do
    render
  end
end
