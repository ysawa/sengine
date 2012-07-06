require 'spec_helper'

describe FeedbacksController do

  def valid_attributes
    {}
  end

  def valid_session
    {}
  end

  before :each do
    user_sign_in
  end

  describe "GET index" do
    it "assigns all feedbacks as @feedbacks" do
      feedback = Feedback.create! valid_attributes
      get :index, {}
      assigns(:feedbacks).should eq([feedback])
    end
  end

  describe "GET show" do
    it "assigns the requested feedback as @feedback" do
      feedback = Feedback.create! valid_attributes
      get :show, {:id => feedback.to_param}
      assigns(:feedback).should eq(feedback)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Feedback" do
        expect {
          post :create, {:feedback => valid_attributes}
        }.to change(Feedback, :count).by(1)
      end

      it "assigns a newly created feedback as @feedback" do
        post :create, {:feedback => valid_attributes}
        assigns(:feedback).should be_a(Feedback)
        assigns(:feedback).should be_persisted
      end

      it "redirects to the created feedback" do
        post :create, {:feedback => valid_attributes}
        response.should redirect_to(Feedback.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved feedback as @feedback" do
        # Trigger the behavior that occurs when invalid params are submitted
        Feedback.any_instance.stub(:save).and_return(false)
        post :create, {:feedback => {}}
        assigns(:feedback).should be_a_new(Feedback)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Feedback.any_instance.stub(:save).and_return(false)
        post :create, {:feedback => {}}
        response.should_not be_success
      end
    end
  end
end
