require 'rails_helper'

RSpec.describe "UserSessions", type: :request do
  describe "GET /user_sessions" do
    it "テスト疎通確認" do
      get new_user_session_path
      expect(response).to have_http_status(200)
    end
  end
end
