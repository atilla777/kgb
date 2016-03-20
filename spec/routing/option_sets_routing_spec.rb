require "rails_helper"

RSpec.describe OptionSetsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/option_sets").to route_to("option_sets#index")
    end

    it "routes to #new" do
      expect(:get => "/option_sets/new").to route_to("option_sets#new")
    end

    it "routes to #show" do
      expect(:get => "/option_sets/1").to route_to("option_sets#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/option_sets/1/edit").to route_to("option_sets#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/option_sets").to route_to("option_sets#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/option_sets/1").to route_to("option_sets#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/option_sets/1").to route_to("option_sets#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/option_sets/1").to route_to("option_sets#destroy", :id => "1")
    end

  end
end
