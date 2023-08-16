require "rails_helper"

RSpec.describe DenominationsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/denominations").to route_to("denominations#index")
    end

    it "routes to #show" do
      expect(get: "/denominations/1").to route_to("denominations#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/denominations").to route_to("denominations#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/denominations/1").to route_to("denominations#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/denominations/1").to route_to("denominations#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/denominations/1").to route_to("denominations#destroy", id: "1")
    end
  end
end
