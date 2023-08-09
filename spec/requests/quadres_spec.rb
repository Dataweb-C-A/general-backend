require 'rails_helper'

RSpec.describe "Quadres", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/quadres/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /private:quadre_params" do
    it "returns http success" do
      get "/quadres/private:quadre_params"
      expect(response).to have_http_status(:success)
    end
  end

end
