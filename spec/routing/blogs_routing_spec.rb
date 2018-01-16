require "rails_helper"

RSpec.describe BlogsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/blogs").to route_to("blogs#index")
    end

    it "routes to #show" do
      expect(:get => "/blogs/1").to route_to("blogs#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/blogs").to route_to("blogs#create")
    end
  end
end
