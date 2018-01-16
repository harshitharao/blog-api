require 'rails_helper'

RSpec.describe "Blogs", type: :request do
  describe "GET /blogs" do
    it "returns succesfull response for list of blogs" do
      get blogs_path
      expect(response).to have_http_status(200)
    end
  end
end
