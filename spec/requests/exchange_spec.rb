require 'rails_helper'

RSpec.describe "Exchanges", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/exchange/index"
      expect(response).to have_http_status(:success)
    end
  end

end
