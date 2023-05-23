require 'rails_helper'

RSpec.describe "Draws", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/draws/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/draws/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/draws/create"
      expect(response).to have_http_status(:success)
    end
  end

end
