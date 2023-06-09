require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "ヘッダー" do
    let!(:user) { create(:user) }
    subject { response.body }

    context "ユーザーがログインしている場合" do
      it "ログイン後に表示されるべきリンクがレスポンスに含まれていること" do
        sign_in user
        get root_path
        expect(subject).to include "BranChannel</a>"
        expect(subject).to include "Home</a>"
        expect(subject).to include "BranChannelとは</a>"
        expect(subject).to include "プロフィール</a>"
        expect(subject).to include "ログアウト</a>"
        expect(subject).to include "作成</a>"
        expect(subject).to include "一覧</a>"
        expect(subject).to include "挑戦中</a>"
        expect(subject).not_to include "ゲストログイン</a>"
        expect(subject).not_to include "ログイン</a>"
        expect(subject).not_to include "新規登録</a>"
      end
    end

    context "ユーザーがログインしていない場合" do
      it "ログイン前に表示されるべきリンクがレスポンスに含まれていること" do
        get root_path
        expect(subject).to include "BranChannel</a>"
        expect(subject).to include "Home</a>"
        expect(subject).to include "BranChannelとは</a>"
        expect(subject).to include "ゲストログイン</a>"
        expect(subject).to include "ログイン</a>"
        expect(subject).to include "新規登録</a>"
        expect(subject).not_to include "プロフィール</a>"
        expect(subject).not_to include "ログアウト</a>"
        expect(subject).not_to include "作成<a>"
        expect(subject).not_to include "一覧</a>"
        expect(subject).not_to include "挑戦中</a>"
      end
    end
  end

  describe "フッター" do
    it "フッターの情報がレスポンスに含まれていること" do
      get root_path
      expect(response.body).to include "Copyright © 2023 All Rights Reserved."
    end
  end

  describe "GET #top" do
    subject { response.body }

    it "トップページに必要な情報がレスポンスに含まれていること" do
      get root_path
      expect(subject).to include "クエストを覗いてみる</a>"
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
      let!(:noticer) { create(:noticer) }
      before do
        sign_in user
        get pages_profile_path
      end

      it "プロフィールページのアクセスが成功すること" do
        expect(response).to have_http_status(200)
      end

      it "ユーザー名、達成クエスト数、作成クエスト数、獲得経験値がレスポンスに含まれていること" do
        expect(subject).to include user.name
        expect(subject).to include "クエスト作成数"
        expect(subject).to include "クエスト達成数"
        expect(subject).to include "獲得経験値"
        expect(subject).to include "7</a>"
        expect(subject).to include "3</a>"
        expect(subject).to include "100pt"
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
        user.grade = "First Stepper"
        params_challenge = { quest_id: quest1.id, close: true }
        patch challenge_path(challenge1), params: { challenge: params_challenge }
        get pages_profile_path
        expect(subject).not_to include "First Stepper"
        expect(subject).to include "Second Stepper"
        expect(subject).to include "次の称号まで40ポイント"
      end

      it "経験値70ポイント未満はSecond Stepperがレスポンスに含まれること" do
        user.having_xp = 68
        user.grade = "Second Stepper"
        params_challenge = { quest_id: quest1.id, close: true }
        patch challenge_path(challenge1), params: { challenge: params_challenge }
        get pages_profile_path
        expect(subject).not_to include "Second Stepper"
        expect(subject).to include "Noticer"
        expect(subject).to include "次の称号まで50ポイント"
      end

      it "経験値120ポイント未満はNoticerがレスポンスに含まれること" do
        user.having_xp = 118
        user.grade = "Noticer"
        params_challenge = { quest_id: quest1.id, close: true }
        patch challenge_path(challenge1), params: { challenge: params_challenge }
        get pages_profile_path
        expect(subject).not_to include "Noticer"
        expect(subject).to include "Discoverer"
        expect(subject).to include "次の称号まで60ポイント"
      end

      it "経験値180ポイント未満はDiscovererがレスポンスに含まれること" do
        user.having_xp = 178
        user.grade = "Discoverer"
        params_challenge = { quest_id: quest1.id, close: true }
        patch challenge_path(challenge1), params: { challenge: params_challenge }
        get pages_profile_path
        expect(subject).not_to include "Discoverer"
        expect(subject).to include "Changer"
        expect(subject).to include "次の称号まで70ポイント"
      end

      it "経験値250ポイント未満はChangerがレスポンスに含まれること" do
        user.having_xp = 248
        user.grade = "Changer"
        params_challenge = { quest_id: quest1.id, close: true }
        patch challenge_path(challenge1), params: { challenge: params_challenge }
        get pages_profile_path
        expect(subject).not_to include "Changer"
        expect(subject).to include "Challenger"
        expect(subject).to include "次の称号まで80ポイント"
      end

      it "経験値330ポイント未満はChallengerがレスポンスに含まれること" do
        user.having_xp = 328
        user.grade = "Challenger"
        params_challenge = { quest_id: quest1.id, close: true }
        patch challenge_path(challenge1), params: { challenge: params_challenge }
        get pages_profile_path
        expect(subject).not_to include "Challenger"
        expect(subject).to include "Accomplisher"
        expect(subject).to include "次の称号まで90ポイント"
      end

      it "経験値420ポイント未満はAccomplisherがレスポンスに含まれること" do
        user.having_xp = 418
        user.grade = "Accomplisher"
        params_challenge = { quest_id: quest1.id, close: true }
        patch challenge_path(challenge1), params: { challenge: params_challenge }
        get pages_profile_path
        expect(subject).not_to include "Accomplisher"
        expect(subject).to include "Legend"
        expect(subject).to include "次の称号まで0ポイント"
      end

      it "経験値420ポイント以上はLegendがレスポンスに含まれること" do
        user.having_xp = 518
        user.grade = "Legend"
        params_challenge = { quest_id: quest1.id, close: true }
        patch challenge_path(challenge1), params: { challenge: params_challenge }
        get pages_profile_path
        expect(subject).to include "Legend"
        expect(subject).to include "次の称号まで0ポイント"
      end
    end
  end

  context "GET #withdraw" do
    let!(:user) { create(:user) }
    subject { response.body }

    it "ユーザー退会及びキャンセルボタンがレスポンスに含まれていること" do
      sign_in user
      get pages_withdraw_path
      expect(subject).to include "ユーザー退会</a>"
      expect(subject).to include "キャンセル</a>"
    end
  end
end
