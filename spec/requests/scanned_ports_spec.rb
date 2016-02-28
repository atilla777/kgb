require 'rails_helper'

RSpec.describe "ScannedPorts", type: :request do
  describe "GET /scanned_ports" do
    it "works! (now write some real specs)" do
      get scanned_ports_path
      expect(response).to have_http_status(200)
    end
  end
end
