require 'rails_helper'

RSpec.describe "Api::Logouts", type: :request do
  describe "GET /api/logouts" do
    it "works! (now write some real specs)" do
      get api_logouts_path
      expect(response).to have_http_status(200)
    end
  end
end
