require 'rails_helper'

RSpec.describe "UserRegistrations", type: :request do
  describe "GET /user_registrations" do
    it "テスト疎通確認" do
      get new_user_registration_path
      expect(response).to have_http_status(200)
    end
  end
end
