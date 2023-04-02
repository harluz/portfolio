require 'rails_helper'

RSpec.describe "UserSessions", type: :request do
  describe "GET /user_sessions" do
    it "ログインページのgetリクエストが成功していること" do
      get new_user_session_path
      expect(response).to have_http_status(200)
    end
  end

  describe "ログインに成功する場合" do
    let(:user) { create(:user) }

    before do
      valid_params = { email: user.email, password: user.password }
      post user_session_path, params: { user: valid_params }
    end

    it "〇〇ページにリダイレクトされていること" do
      expect(response).to redirect_to pages_main_path
    end

    it "ステータスコード303（リダイレクト）がレスポンスされていること" do
      expect(response).to have_http_status(303)
    end

    it "許可されているページにアクセスした際、ステータスコード200がレスポンスされていること" do
      get pages_main_path
      expect(response).to have_http_status(200)
    end
  end

  describe "ログイン失敗もしくは未ログインの場合" do
    let(:non_correct_user) { build(:non_correct_user) }
    before do
      invalid_params = { email: non_correct_user.email, password: non_correct_user.password }
      post user_session_path, params: { user: invalid_params }
    end

    it "ステータスコード422(バリデーションエラー)がレスポンスされていること" do
      expect(response).to have_http_status(422)
    end

    it "許可されていないページにアクセスした際、ステータスコード302（リダイレクト）がレスポンスされていること" do
      get pages_main_path
      expect(response).to have_http_status(302)
    end
  end
end
