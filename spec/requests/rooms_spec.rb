require 'rails_helper'

RSpec.describe "Rooms", type: :request do
  let!(:user) { create(:user) }
  let(:other_user) { create(:correct_user) }
  let!(:quest) { create(:quest, user: user) }
  let(:non_public_quest) { create(:non_public_quest, user: other_user) }
  let!(:room) { create(:room, quest: quest) }
  let!(:other_room) { create(:room, quest: non_public_quest) }
  let!(:message) { create(:message, user: user, room: room, content: "My message", created_at: "2023-04-1 12:00:00") }
  let!(:other_message) do
    create(:message, user: other_user, room: room, content: "Other message", created_at: "2023-04-2 12:12:00")
  end

  describe "GET #show" do
    subject { response.body }

    context "ユーザーがログインしている場合" do
      before do
        sign_in user
        get quest_room_path(room.quest, room)
      end

      it "トークルームのgetリクエストが成功していること" do
        expect(response).to have_http_status(200)
      end

      it "トークルームに必要な情報がレスポンスに含まれていること" do
        expect(subject).to include room.quest.title
        expect(subject).to include "クエストについて語ってみよう"
        expect(subject).to include "textarea"
        expect(subject).to include "送信"
        expect(subject).to include message.content
        expect(subject).to include "2023/04/01 12:00"
        expect(subject).to include other_message.content
        expect(subject).to include "2023/04/02 12:12"
        expect(subject).to include "コメント削除"
      end

      context "存在しないトークルームにアクセスしようとした場合" do
        before do
          get quest_room_path(room.quest, 0)
        end

        it "ステータスコード302（リダイレクト）がレスポンスされていること" do
          expect(response).to have_http_status(302)
        end

        it "クエスト一覧ページにリダイレクトするレスポンスが含まれていること" do
          expect(subject).to redirect_to quests_path
        end
      end

      context "他ユーザーの非公開クエストのトークルームにアクセスしようとした場合" do
        before do
          get quest_room_path(other_room.quest, other_room)
        end

        it "ステータスコード302（リダイレクト）がレスポンスされていること" do
          expect(response).to have_http_status(302)
        end

        it "クエスト一覧ページにリダイレクトするレスポンスが含まれていること" do
          expect(subject).to redirect_to quests_path
        end
      end
    end

    context "ユーザーがログインしていない場合" do
      before do
        get quest_room_path(room.quest, room)
      end

      it "ステータスコード302（リダイレクト）がレスポンスされていること" do
        expect(response).to have_http_status(302)
      end

      it "sign_inページにリダイレクトするレスポンスが含まれていること" do
        expect(subject).to redirect_to new_user_session_path
      end
    end
  end

  describe "DELETE dependent: :destroy" do
    context "ユーザー自身のクエストを削除した場合" do
      it "room数が減少していること" do
        expect do
          quest.destroy
        end.to change(Room, :count).by(-1)
      end
    end

    context "他ユーザーのトークルームを削除しようとした場合" do
      it "RoutingErrorが発生すること" do
        expect do
          sign_in user
          delete quest_room_path(non_public_quest, other_room)
        end.to raise_error(ActionController::RoutingError)
      end
    end

    context "存在しないトークルームを削除しようとした場合" do
      it "RoutingErrorが発生すること" do
        sign_in user
        expect do
          delete quest_room_path(non_public_quest, 0)
        end.to raise_error(ActionController::RoutingError)
      end
    end

    context "他ユーザーの非公開クエストのトークルームを削除しようとした場合" do
      it "RoutingErrorが発生すること" do
        sign_in user
        expect do
          delete quest_room_path(non_public_quest, other_room)
        end.to raise_error(ActionController::RoutingError)
      end
    end
  end
end
