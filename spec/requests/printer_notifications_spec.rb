require 'rails_helper'

RSpec.describe "PrinterNotifications", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/printer_notifications/index"
      expect(response).to have_http_status(:success)
    end
  end

end
