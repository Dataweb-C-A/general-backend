require 'rails_helper'

RSpec.describe "Inboxes", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/inboxes/index"
      expect(response).to have_http_status(:success)
    end
  end

end
