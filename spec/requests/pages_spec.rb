require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "GET /top" do
    it "returns http success" do
      get "/pages/top"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #profile" do
    let!(:user) { create(:user) }
    let!(:quest1) { create(:quest, user: user) }
    let!(:quest2) { create(:quest, user: user) }
    let!(:quest3) { create(:quest, user: user) }
    let(:challenge1) { create(:challenge, user: user, quest: quest1) }
    let(:challenge2) { create(:challenge, user: user, quest: quest2) }
    subject { response.body }

    context "ユーザーがログインしている場合" do
      before do
        sign_in user
        get pages_profile_path
      end

      it "プロフィールページのアクセスが成功すること" do
        expect(response).to have_http_status(200)
      end

      it "ユーザー名、達成クエスト数、作成クエスト数、獲得経験値がレスポンスに含まれていること" do
        challenge1.close = true
        challenge2.close = true
        expect(subject).to include user.name
        expect(subject).to include "2"
        expect(subject).to include "3"
        expect(subject).to include "100"
      end
    end

    context "ユーザーがログインしていない場合" do
      before { get pages_profile_path }

      it "ステータスコード302（リダイレクト）がレスポンスされていること" do
        expect(response).to have_http_status(302)
      end

      it "sign_inページにリダイレクトするレスポンスが含まれていること" do
        expect(subject).to redirect_to new_user_session_path
      end
    end
  end
end
