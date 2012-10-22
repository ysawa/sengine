require 'spec_helper'

describe "comments/index" do
  before(:each) do
    user_sign_in
    assign(:comments, [
      stub_model(Comment,
        :content => "Content"
      ),
      stub_model(Comment,
        :content => "Content"
      )
    ])
  end

  it "renders a list of comments" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Content".to_s, :count => 2
  end
end
