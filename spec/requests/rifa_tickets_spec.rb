require 'rails_helper'

RSpec.describe "RifaTickets", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/rifa_tickets/index"
      expect(response).to have_http_status(:success)
    end
  end

end
