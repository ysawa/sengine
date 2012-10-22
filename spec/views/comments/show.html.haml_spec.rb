require 'spec_helper'

describe "comments/show" do
  before(:each) do
    user_sign_in
    @comment = assign(:comment, stub_model(Comment,
      :content => "Content"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Content/)
  end
end
