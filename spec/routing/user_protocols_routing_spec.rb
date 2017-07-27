require "rails_helper"

RSpec.describe UserProtocolsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/user_protocols").to route_to("user_protocols#index")
    end

    it "routes to #new" do
      expect(:get => "/user_protocols/new").to route_to("user_protocols#new")
    end

    it "routes to #show" do
      expect(:get => "/user_protocols/1").to route_to("user_protocols#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/user_protocols/1/edit").to route_to("user_protocols#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/user_protocols").to route_to("user_protocols#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/user_protocols/1").to route_to("user_protocols#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/user_protocols/1").to route_to("user_protocols#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/user_protocols/1").to route_to("user_protocols#destroy", :id => "1")
    end

  end
end
