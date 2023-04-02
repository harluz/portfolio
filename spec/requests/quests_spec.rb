require 'rails_helper'

RSpec.describe "Quests", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/quests/index"
      expect(response).to have_http_status(:success)
    end
  end

end
