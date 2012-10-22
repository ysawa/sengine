require 'spec_helper'

describe "comments/new" do
  before(:each) do
    user_sign_in
    @game = Fabricate(:game)
    @comment = Comment.new(game: @game)
    assign(:comment, @comment)
  end

  it "renders new comment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", action: game_comments_path(@game), method: "post" do
      assert_select "textarea#comment_content", name: "comment[content]"
    end
  end
end
