require 'spec_helper'

describe CommentsController do

  def valid_attributes
    { game_id: @game.id }
  end

  def valid_session
    {}
  end

  before :each do
    user_sign_in
    @game = Fabricate(:game)
  end

  describe "GET index" do
    it "assigns all comments as @comments" do
      comment = Comment.create! valid_attributes
      get :index, { game_id: @game.to_param }
      assigns(:comments).should eq([comment])
    end
  end

  describe "GET show" do
    it "assigns the requested comment as @comment" do
      comment = Comment.create! valid_attributes
      get :show, { game_id: @game.to_param, id: comment.to_param}
      assigns(:comment).should eq(comment)
    end
  end

  describe "GET new" do
    it "assigns a new comment as @comment" do
      get :new, { game_id: @game.to_param, game_id: @game.to_param }
      assigns(:comment).should be_a_new(Comment)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Comment" do
        expect {
          post :create, { game_id: @game.to_param, comment: valid_attributes}
        }.to change(Comment, :count).by(1)
      end

      it "assigns a newly created comment as @comment" do
        post :create, { game_id: @game.to_param, comment: valid_attributes}
        assigns(:comment).should be_a(Comment)
        assigns(:comment).should be_persisted
      end

      it "redirects to the created comment" do
        post :create, { game_id: @game.to_param, comment: valid_attributes}
        response.should redirect_to(game_comment_path @game, Comment.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved comment as @comment" do
        # Trigger the behavior that occurs when invalid params are submitted
        Comment.any_instance.stub(:save).and_return(false)
        post :create, { game_id: @game.to_param, comment: {}}
        assigns(:comment).should be_a_new(Comment)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Comment.any_instance.stub(:save).and_return(false)
        post :create, { game_id: @game.to_param, comment: {}}
        response.should render_template("new")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested comment" do
      comment = Comment.create! valid_attributes
      expect {
        delete :destroy, { game_id: @game.to_param, id: comment.to_param}
      }.to change(Comment, :count).by(-1)
    end

    it "redirects to the comments list" do
      comment = Comment.create! valid_attributes
      delete :destroy, { game_id: @game.to_param, id: comment.to_param}
      response.should redirect_to(game_comments_path @game)
    end
  end

end
