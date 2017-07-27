require 'rails_helper'

RSpec.describe "UserProtocols", type: :request do
  describe "GET /user_protocols" do
    it "works! (now write some real specs)" do
      get user_protocols_path
      expect(response).to have_http_status(200)
    end
  end
end
