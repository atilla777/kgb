require "rails_helper"

RSpec.describe ScannedPortsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/scanned_ports").to route_to("scanned_ports#index")
    end

    it "routes to #new" do
      expect(:get => "/scanned_ports/new").to route_to("scanned_ports#new")
    end

    it "routes to #show" do
      expect(:get => "/scanned_ports/1").to route_to("scanned_ports#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/scanned_ports/1/edit").to route_to("scanned_ports#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/scanned_ports").to route_to("scanned_ports#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/scanned_ports/1").to route_to("scanned_ports#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/scanned_ports/1").to route_to("scanned_ports#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/scanned_ports/1").to route_to("scanned_ports#destroy", :id => "1")
    end

  end
end
