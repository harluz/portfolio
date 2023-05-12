require 'rails_helper'

RSpec.describe "UserSessions", type: :request do
  describe "GET #new" do
    subject { response }

    it "ログインページのgetリクエストが成功していること" do
      get new_user_session_path
      expect(subject).to have_http_status(200)
    end
  end

  describe "POST #create" do
    let(:user) { create(:user) }
    let(:non_correct_user) { build(:non_correct_user) }
    subject { response }

    context "ログインに成功する場合" do
      before do
        valid_params = { email: user.email, password: user.password }
        post user_session_path, params: { user: valid_params }
      end

      it "挑戦一覧ページにリダイレクトされていること" do
        expect(subject).to redirect_to challenges_path
      end

      it "ステータスコード303（リダイレクト）がレスポンスされていること" do
        expect(subject).to have_http_status(303)
      end

      it "許可されているページにアクセスした際、ステータスコード200がレスポンスされていること" do
        get challenges_path
        expect(subject).to have_http_status(200)
      end
    end

    context "ログイン失敗もしくは未ログインの場合" do
      before do
        invalid_params = { email: non_correct_user.email, password: non_correct_user.password }
        post user_session_path, params: { user: invalid_params }
      end

      it "ステータスコード422(バリデーションエラー)がレスポンスされていること" do
        expect(subject).to have_http_status(422)
      end

      it "許可されていないページにアクセスした際、ステータスコード302（リダイレクト）がレスポンスされていること" do
        get challenges_path
        expect(subject).to have_http_status(302)
      end
    end
  end

  describe "POST #guest_sign_in" do
    subject { response }

    before do
      post users_guest_sign_in_path
    end

    it "〇〇ページにリダイレクトされていること" do
      expect(subject).to redirect_to root_path
    end

    it "ステータスコード303（リダイレクト）がレスポンスされていること" do
      expect(subject).to have_http_status(302)
    end
  end

  describe "DELET #destroy" do
    let(:user) { create(:user) }
    subject { response }

    context "ログアウトに成功する場合" do
      before do
        valid_params = { email: user.email, password: user.password }
        post user_session_path, params: { user: valid_params }
        delete destroy_user_session_path
      end

      it "ログアウトに成功しルートページにリダイレクトされていること" do
        expect(subject).to redirect_to root_path
      end

      it "ログアウトに成功しステータスコード303（リダイレクト）がレスポンスされていること" do
        expect(subject).to have_http_status(303)
      end
    end
  end
end
