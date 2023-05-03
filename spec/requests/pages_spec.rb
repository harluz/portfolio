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
    let!(:quest1) { create(:quest, user: user, xp: 2) }
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
        expect(subject).to include user.email
        expect(subject).to include "2"
        expect(subject).to include "3"
        expect(subject).to include "100"
        expect(subject).to include "ユーザー編集"
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

    context "ユーザーの経験値が増加した場合" do
      let!(:first_stepper) { create(:first_stepper) }
      let!(:second_stepper) { create(:second_stepper) }
      let!(:noticer) { create(:noticer) }
      let!(:discoverer) { create(:discoverer) }
      let!(:changer) { create(:changer) }
      let!(:challenger) { create(:challenger) }
      let!(:accomplisher) { create(:accomplisher) }
      let!(:legend) { create(:legend) }
      before do
        sign_in user
      end

      it "経験値30ポイント未満はFirst Stepperがレスポンスに含まれること" do
        user.having_xp = 28
        params_challenge = { quest_id: quest1.id, close: true }
        patch challenge_path(challenge1), params: { challenge: params_challenge }
        get pages_profile_path
        expect(subject).not_to include "First Stepper"
        expect(subject).to include "Second Stepper"
      end

      it "経験値70ポイント未満はSecond Stepperがレスポンスに含まれること" do
        user.having_xp = 68
        user.grade = "Second Stepper"
        params_challenge = { quest_id: quest1.id, close: true }
        patch challenge_path(challenge1), params: { challenge: params_challenge }
        get pages_profile_path
        expect(subject).not_to include "Second Stepper"
        expect(subject).to include "Noticer"
      end

      it "経験値120ポイント未満はNoticerがレスポンスに含まれること" do
        user.having_xp = 118
        user.grade = "Noticer"
        params_challenge = { quest_id: quest1.id, close: true }
        patch challenge_path(challenge1), params: { challenge: params_challenge }
        get pages_profile_path
        expect(subject).not_to include "Noticer"
        expect(subject).to include "Discoverer"
      end

      it "経験値180ポイント未満はDiscovererがレスポンスに含まれること" do
        user.having_xp = 178
        user.grade = "Discoverer"
        params_challenge = { quest_id: quest1.id, close: true }
        patch challenge_path(challenge1), params: { challenge: params_challenge }
        get pages_profile_path
        expect(subject).not_to include "Discoverer"
        expect(subject).to include "Changer"
      end

      it "経験値250ポイント未満はChangerがレスポンスに含まれること" do
        user.having_xp = 248
        user.grade = "Changer"
        params_challenge = { quest_id: quest1.id, close: true }
        patch challenge_path(challenge1), params: { challenge: params_challenge }
        get pages_profile_path
        expect(subject).not_to include "Changer"
        expect(subject).to include "Challenger"
      end

      it "経験値320ポイント未満はChallengerがレスポンスに含まれること" do
        user.having_xp = 318
        user.grade = "Challenger"
        params_challenge = { quest_id: quest1.id, close: true }
        patch challenge_path(challenge1), params: { challenge: params_challenge }
        get pages_profile_path
        expect(subject).not_to include "Challenger"
        expect(subject).to include "Accomplisher"
      end

      it "経験値400ポイント未満はAccomplisherがレスポンスに含まれること" do
        user.having_xp = 398
        user.grade = "Accomplisher"
        params_challenge = { quest_id: quest1.id, close: true }
        patch challenge_path(challenge1), params: { challenge: params_challenge }
        get pages_profile_path
        expect(subject).not_to include "Accomplisher"
        expect(subject).to include "Legend"
      end

      it "経験値400ポイント以上はLegendがレスポンスに含まれること" do
        user.having_xp = 498
        user.grade = "Legend"
        params_challenge = { quest_id: quest1.id, close: true }
        patch challenge_path(challenge1), params: { challenge: params_challenge }
        get pages_profile_path
        expect(subject).to include "Legend"
      end
    end
  end
end
