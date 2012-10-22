require "spec_helper"

describe CommentsController do
  describe "routing" do

    it "routes to #create" do
      post("/games/1/comments").should route_to("comments#create", game_id: "1")
    end

    it "routes to #destroy" do
      delete("/games/1/comments/1").should route_to("comments#destroy", id: "1", game_id: "1")
    end

    it "routes to #index" do
      get("/games/1/comments").should route_to("comments#index", game_id: "1")
    end

    it "routes to #new" do
      get("/games/1/comments/new").should route_to("comments#new", game_id: "1")
    end

    it "routes to #show" do
      get("/games/1/comments/1").should route_to("comments#show", id: "1", game_id: "1")
    end
  end
end
