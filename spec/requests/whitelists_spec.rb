require 'rails_helper'

RSpec.describe "Whitelists", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/whitelists/index"
      expect(response).to have_http_status(:success)
    end
  end

end
