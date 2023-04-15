require 'rails_helper'

RSpec.describe "Challenges", type: :request do
  let!(:user) { create(:user) }
  let(:other_user) { create(:correct_user) }
  let(:public_quest) { create(:public_quest, user: user) }
  let(:non_public_quest) { create(:non_public_quest, user: user) }
  let(:other_public_quest) { create(:public_other_quest, user: other_user) }
  let(:other_non_public_quest) { create(:other_quest, user: other_user) }

  describe "GET #index" do
    subject{ response.body }

    context "ユーザーがログインしている場合" do
      before { sign_in user }
      
      it "挑戦リストページのgetリクエストが成功していること" do
        get challenges_path
        expect(response).to have_http_status(200)
      end

      context "挑戦中のクエストがある場合" do
        let!(:public_quest_challenge) { create(:challenge, user_id: user.id, quest_id: public_quest.id) }
        let!(:non_public_quest_challenge) { create(:challenge, user_id: user.id, quest_id: non_public_quest.id) }
        let!(:non_public_other_quest_challenge) { create(:challenge, user_id: other_user.id, quest_id: other_non_public_quest.id) }

        before { get challenges_path }

        it "自身の挑戦中のクエストのみレスポンスされていること" do
          expect(subject).to include public_quest.title
          expect(subject).to include non_public_quest.title
          expect(subject).not_to include other_non_public_quest.title
        end

        it "詳細・達成・諦めるのリンク及びボタンが正しくレスポンスされていること" do
          expect(subject).to include "<a href=\"/quests/#{public_quest_challenge.quest.id}\">詳細</a>"
          expect(subject).to include
          "<a rel=\"nofollow\" data-method=\"delete\" href=\"/challenges/#{public_quest_challenge.id}\">諦める</a>"
          expect(subject).to include
          "id=\"/close_challenge_#{public_quest_challenge.id}\""
          expect(subject).not_to include "<a href=\"/quests/#{non_public_other_quest_challenge.quest.id}\">詳細</a>"
          expect(subject).not_to include
          "<a rel=\"nofollow\" data-method=\"delete\" href=\"/challenges/#{non_public_other_quest_challenge.id}\">諦める</a>"
          expect(subject).not_to include
          "id=\"/close_challenge_#{non_public_other_quest_challenge.id}\""
        end
      end

      context "挑戦中のクエストがない場合" do
        it "挑戦中のクエストがないメッセージがレスポンスに含まれていること" do
          get challenges_path
          expect(subject).to include "挑戦中のクエストがありません"
        end
      end
    end

    context "ユーザーがログインしていない場合" do
      before { get challenges_path }

      it "ステータスコード302（リダイレクト）がレスポンスされていること" do
        expect(response).to have_http_status(302)
      end

      it "sign_inページにリダイレクトするレスポンスが含まれていること" do
        expect(subject).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET #closed" do
    subject{ response.body }

    context "ユーザーがログインしている場合" do
      before { sign_in user }

      context "達成したクエストがある場合" do
        let!(:public_quest_challenge) { create(:closed_challenge, user_id: user.id, quest_id: public_quest.id) }
        let!(:non_public_quest_challenge) { create(:closed_challenge, user_id: user.id, quest_id: non_public_quest.id) }
        let!(:public_other_quest_challenge) { create(:closed_challenge, user_id: other_user.id, quest_id: other_public_quest.id) }
        let!(:non_public_other_quest_challenge) { create(:closed_challenge, user_id: other_user.id, quest_id: other_non_public_quest.id) }

        before { get closed_challenges_path }

        it "自身の達成したクエストのみレスポンスされていること" do
          expect(subject).to include public_quest.title
          expect(subject).to include non_public_quest.title
          expect(subject).not_to include other_public_quest.title
          expect(subject).not_to include other_non_public_quest.title
        end

        it "詳細・達成・諦めるのリンク及びボタンが正しくレスポンスされていること" do
          expect(subject).to include "<a href=\"/quests/#{public_quest_challenge.quest.id}\">詳細</a>"
          expect(subject).to include
          "id=\"/retry_#{public_quest_challenge.id}\""
          expect(subject).not_to include "<a href=\"/quests/#{public_other_quest_challenge.quest.id}\">詳細</a>"
          expect(subject).not_to include
          "id=\"/retry_#{public_other_quest_challenge.id}\""
        end
      end

      context "達成したクエストがない場合" do
        it "達成したクエストがないメッセージがレスポンスに含まれていること" do
          get closed_challenges_path
          expect(subject).to include "達成したクエストがありません"
        end
      end
    end

    context "ユーザーがログインしていない場合" do
      before { get closed_challenges_path }

      it "ステータスコード302（リダイレクト）がレスポンスされていること" do
        expect(response).to have_http_status(302)
      end

      it "sign_inページにリダイレクトするレスポンスが含まれていること" do
        expect(subject).to redirect_to new_user_session_path
      end
    end
  end

  describe "POST #create " do
    subject { response }
    before { sign_in user }

    context "challengeの作成に成功する場合" do
      it "challengeの数が増加していること" do
        expect do
          params_challenge = {
            quest_id: public_quest.id,
            close: false,
          }
          post challenges_path, params: { challenge: params_challenge }
        end.to change(Challenge, :count).by(1)
      end

      describe "レスポンス確認" do
        before do
          params_challenge = {
            quest_id: public_quest.id,
            close: false,
          }
          post challenges_path, params: { challenge: params_challenge }
        end

        it "ステータスコード302（リダイレクト）がレスポンスされていること" do
          expect(subject).to have_http_status(302)
        end

        it "挑戦リストにリダイレクトするレスポンスが含まれていること" do
          expect(subject).to redirect_to challenges_path
        end
      end
    end

    context "challengeの作成に失敗する場合" do
      it "challengeの数が増加していないこと" do
        expect do
          params_challenge = {
            quest_id: other_non_public_quest.id,
            close: false,
          }
          post challenges_path, params: { challenge: params_challenge }
        end.to change(Challenge, :count).by(0)
      end

      describe "レスポンス確認" do
        before do
          params_challenge = {
            quest_id: other_non_public_quest.id,
            close: false,
          }
          post challenges_path, params: { challenge: params_challenge }
        end
        
        it "ステータスコード302（リダイレクト）がレスポンスされていること" do
          expect(subject).to have_http_status(302)
        end

        it "挑戦リストにリダイレクトするレスポンスが含まれていること" do
          expect(subject).to redirect_to challenges_path
        end
      end
    end
  end

  describe "PATCH #update" do
    context "challengeの更新に成功する場合" do
      
    end
    context "challengeの更新に失敗する場合" do
      # 他ユーザーの非公開クエストに挑戦しようとした場合失敗すること
    end
    context "存在しないデータでchallengeを更新しようとした場合" do
      # 存在しないユーザーIDでchallengeを更新できないこと
      # 存在しないクエストIDでchallengeを更新できないこと
    end
  end
  describe "DELETE #destroy" do
    context "ユーザー自身のchallengeを削除する場合" do
      describe "レスポンス確認" do
        
      end
    end

    context "他ユーザーのchallengeを削除しようとした場合" do
      describe "レスポンス確認" do
        
      end
    end

    context "存在しないchallengeを削除しようとした場合" do
      describe "レスポンス確認" do

      end
    end
  end
end
