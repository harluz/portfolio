require 'rails_helper'

RSpec.describe "Quests", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:correct_user) }

  describe "GET #index" do
    let!(:quest) { create(:public_quest, user: user) }
    let!(:non_public_quest) { create(:non_public_quest, user: user) }
    let!(:other_quest) { create(:public_other_quest, user: other_user) }
    let!(:non_public_other_quest) { create(:other_quest, user: other_user) }
    subject { response.body }

    context "ユーザーがログインしている場合" do
      before do
        sign_in user
        get quests_path
      end

      it "quest一覧ページのgetリクエストが成功していること" do
        expect(response).to have_http_status(200)
      end

      it "公開questが表示されていること" do
        expect(subject).to include "キーワードを一つ入力してください。"
        expect(subject).to include "検索"
        expect(subject).to include quest.title
        expect(subject).to include "難易度:#{quest.difficulty}"
        expect(subject).to include other_quest.title
        expect(subject).to include "難易度:#{other_quest.difficulty}"
        expect(subject).to include "詳細"
        expect(subject).not_to include non_public_quest.title
        expect(subject).not_to include non_public_other_quest.title
      end
    end

    context "ユーザーがログインしていない場合" do
      before { get quests_path }

      it "quest一覧ページのgetリクエストが成功していること" do
        expect(response).to have_http_status(200)
      end

      it "公開questが表示されていること" do
        expect(subject).to include "キーワードを一つ入力してください。"
        expect(subject).to include "検索"
        expect(subject).to include quest.title
        expect(subject).to include "難易度:#{quest.difficulty}"
        expect(subject).to include other_quest.title
        expect(subject).to include "難易度:#{other_quest.difficulty}"
        expect(subject).to include "詳細"
        expect(subject).not_to include non_public_quest.title
        expect(subject).not_to include non_public_other_quest.title
      end
    end
  end

  describe "GET #index prams[search]" do
    subject { response.body }
    before { sign_in user }
    context "キーワード検索を行なった場合" do
      let!(:public_quest1) { create(:public_quest, user: user, title: "sample sentence") }
      let!(:public_quest2) { create(:public_quest, user: user, title: "keyword search") }
      let!(:public_quest3) { create(:public_quest, user: other_user, title: "sample quest") }
      let!(:non_public_quest1) { create(:non_public_quest, user: user, title: "sample input") }
      let!(:non_public_quest2) { create(:non_public_quest, user: other_user, title: "sample hoge") }

      it "キーワードに関連した公開クエストがレスポンスに含まれていること" do
        get quests_path, params: { search: "sample" }
        expect(subject).to include public_quest1.title
        expect(subject).to include public_quest3.title
        expect(subject).not_to include public_quest2.title
        expect(subject).not_to include non_public_quest1.title
        expect(subject).not_to include non_public_quest2.title
      end

      it "あいまい検索が機能し、関連した公開クエストがレスポンスに含まれていること" do
        get quests_path, params: { search: "samp" }
        expect(subject).to include public_quest1.title
        expect(subject).to include public_quest3.title
        expect(subject).not_to include public_quest2.title
        expect(subject).not_to include non_public_quest1.title
        expect(subject).not_to include non_public_quest2.title
      end

      it "検索フォームが空の状態で検索をクリックした際は、すべての公開クエストがレスポンスに含まれていること" do
        get quests_path, params: { search: "" }
        expect(subject).to include public_quest1.title
        expect(subject).to include public_quest2.title
        expect(subject).to include public_quest3.title
        expect(subject).not_to include non_public_quest1.title
        expect(subject).not_to include non_public_quest2.title
      end

      it "キーワードが合致しなかった場合、クエストがレスポンスに含まれていないこと" do
        get quests_path, params: { search: "example" }
        expect(subject).not_to include public_quest1.title
        expect(subject).not_to include public_quest2.title
        expect(subject).not_to include public_quest3.title
        expect(subject).not_to include non_public_quest1.title
        expect(subject).not_to include non_public_quest2.title
      end

      it "複数ワードで検索した場合、最初の単語に関連した公開クエストが表示されること" do
        get quests_path, params: { search: "sample keyword" }
        expect(subject).to include public_quest1.title
        expect(subject).to include public_quest3.title
        expect(subject).not_to include public_quest2.title
        expect(subject).not_to include non_public_quest1.title
        expect(subject).not_to include non_public_quest2.title
      end

      it "キーワードの先頭にスペースがあった場合、スペース後の単語に関連した公開クエストがレスポンスに含まれていること" do
        get quests_path, params: { search: " sample" }
        expect(subject).to include public_quest1.title
        expect(subject).to include public_quest3.title
        expect(subject).not_to include public_quest2.title
        expect(subject).not_to include non_public_quest1.title
        expect(subject).not_to include non_public_quest2.title
      end
    end

    context "キーワード検索でタグ検索が行われた場合" do
      let!(:public_quest1) { create(:public_quest, :tag_name_trip, user: user, title: "sample sentence") }
      let!(:public_quest2) { create(:public_quest, :tag_name_sports, user: user, title: "keyword search") }
      let!(:public_quest3) { create(:public_quest, :tag_name_hobby, user: other_user, title: "sample quest") }
      let!(:non_public_quest1) { create(:non_public_quest, user: user, title: "sample input") }
      let!(:non_public_quest2) { create(:non_public_quest, user: other_user, title: "sample hoge") }

      it "入力されたタグに関連した公開クエストがレスポンスに含まれていること" do
        get quests_path, params: { search: "#trip" }
        expect(subject).to include public_quest1.title
        expect(subject).not_to include public_quest2.title
        expect(subject).not_to include public_quest3.title
        expect(subject).not_to include non_public_quest1.title
        expect(subject).not_to include non_public_quest2.title
      end

      it "複数タグで検索した場合、最初のタグに関連した公開クエストがレスポンスに含まれていること" do
        get quests_path, params: { search: "#sports #hobby" }
        expect(subject).to include public_quest2.title
        expect(subject).not_to include public_quest1.title
        expect(subject).not_to include public_quest3.title
        expect(subject).not_to include non_public_quest1.title
        expect(subject).not_to include non_public_quest2.title
      end

      it "#のみで検索した場合、すべての公開クエストがレスポンスに含まれていること" do
        get quests_path, params: { search: "#" }
        expect(subject).to include public_quest2.title
        expect(subject).to include public_quest1.title
        expect(subject).to include public_quest3.title
        expect(subject).not_to include non_public_quest1.title
        expect(subject).not_to include non_public_quest2.title
      end
    end
  end

  describe "GET #my_quest" do
    let!(:quest) { create(:public_quest, user: user) }
    let!(:non_public_quest) { create(:non_public_quest, user: user) }
    let!(:other_quest) { create(:public_other_quest, user: other_user) }
    let!(:non_public_other_quest) { create(:other_quest, user: other_user) }
    subject { response.body }

    context "ユーザーがログインしている場合" do
      before do
        sign_in user
        get my_quest_quests_path
      end

      it "my_questページのgetリクエストが成功していること" do
        expect(response).to have_http_status(200)
      end

      it "ユーザー自身が作成したquestが表示されていること" do
        expect(subject).to include quest.title
        expect(subject).to include non_public_quest.title
        expect(subject).not_to include other_quest.title
        expect(subject).not_to include non_public_other_quest.title
      end
    end
    context "ユーザーがログインしていない場合" do
      before { get my_quest_quests_path }

      it "ステータスコード302（リダイレクト）がレスポンスされていること" do
        expect(response).to have_http_status(302)
      end

      it "sign_inページにリダイレクトするレスポンスが含まれていること" do
        expect(subject).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET #new" do
    subject { response }

    context "ユーザーがログインしている場合" do
      before do
        sign_in user
        get new_quest_path
      end

      it "quest作成ページのgetリクエストが成功していること" do
        expect(response).to have_http_status(200)
      end

      it "フォームがレスポンスに含まれていること" do
        expect(response.body).to include "クエストタイトル"
        expect(response.body).to include "placeholder=\"（必須）タイトルを入力してください\""
        expect(response.body).to include "クエスト詳細"
        expect(response.body).to include "placeholder=\"ご自由にご記入ください\""
        expect(response.body).to include "難易度"
        5.times do |num|
          expect(response.body).to include "id=\"radio-#{num + 1}\""
        end
        expect(response.body).to include "type=\"checkbox\""
        expect(response.body).to include "クエストを公開する"
        expect(response.body).to include "type=\"submit\""
        expect(response.body).to include "クエスト作成"
      end
    end

    context "ユーザーがログインしていない場合" do
      before { get new_quest_path }

      it "ステータスコード302（リダイレクト）がレスポンスされていること" do
        expect(subject).to have_http_status(302)
      end

      it "sign_inページにリダイレクトするレスポンスが含まれていること" do
        expect(subject).to redirect_to new_user_session_path
      end
    end
  end

  describe "POST #create" do
    subject { response }
    before { sign_in user }

    context "questの作成に成功する場合" do
      it "questの数が増加していること" do
        expect do
          post quests_path, params: { quest_form: attributes_for(:quest_form) }
        end.to change(Quest, :count).by(1)
      end

      describe "レスポンス確認" do
        before { post quests_path, params: { quest_form: attributes_for(:quest_form) } }

        it "showページにリダイレクトされていること" do
          expect(subject).to redirect_to quest_path(user.quests.last)
        end

        it "ステータスコード302（リダイレクト）がレスポンスさていること" do
          expect(subject).to have_http_status(302)
        end
      end
    end

    context "questの作成に失敗する場合" do
      it "questの数が増加していないこと" do
        expect do
          post quests_path, params: { quest_form: attributes_for(:non_correct_quest_form) }
        end.to change(Quest, :count).by(0)
      end

      describe "レスポンス確認" do
        before { post quests_path, params: { quest_form: attributes_for(:non_correct_quest_form) } }

        it "newページにリダイレクトされていること" do
          expect(subject).to redirect_to new_quest_path
        end

        it "ステータスコード302（リダイレクト）がレスポンスさていること" do
          expect(subject).to have_http_status(302)
        end
      end
    end
  end

  describe "GET #show" do
    let!(:quest) { create(:public_quest, user: user) }
    let!(:other_quest) { create(:public_other_quest, user: other_user) }
    let!(:non_public_other_quest) { create(:other_quest, user: other_user) }
    let!(:room) { create(:room, quest: quest) }
    let!(:other_room) { create(:room, quest: other_quest) }
    let!(:non_public_other_room) { create(:room, quest: non_public_other_quest) }
    subject { response }

    context "ユーザーがログインしている場合" do
      before { sign_in user }

      it "showページのgetリクエストが成功していること" do
        get quest_path(quest)
        expect(subject).to have_http_status(200)
      end

      it "他ユーザーの公開クエストのshowページのgetリクエストが成功していること" do
        get quest_path(other_quest)
        expect(subject).to have_http_status(200)
      end

      it "他ユーザーの非公開クエストのshowページはステータスコード302（リダイレクト）がレスポンスされていること" do
        get quest_path(non_public_other_quest)
        expect(subject).to have_http_status(302)
      end

      it "questの情報がレスポンスに含まれていること" do
        get quest_path(quest)
        expect(response.body).to include quest.title
        expect(response.body).to include quest.describe
        expect(response.body).to include quest.difficulty.to_s
        expect(response.body).to include quest.xp.to_s
        expect(response.body).to include "トークルームへ"
        get quest_path(other_quest)
        expect(response.body).to include other_quest.title
        expect(response.body).to include other_quest.describe
        expect(response.body).to include other_quest.difficulty.to_s
        expect(response.body).to include other_quest.xp.to_s
        expect(response.body).to include "トークルームへ"
      end

      context "存在しないquestにアクセスした場合" do
        before { get quest_path(0) }

        it "ステータスコード302（リダイレクト）がレスポンスされていること" do
          expect(subject).to have_http_status(302)
        end

        it "quest一覧ページにリダイレクトするレスポンスが含まれていること" do
          expect(subject).to redirect_to quests_path
        end
      end
    end

    context "ユーザーがログインしていない場合" do
      before { get quest_path(quest) }

      it "ステータスコード302（リダイレクト）がレスポンスされていること" do
        expect(subject).to have_http_status(302)
      end

      it "sign_inページにリダイレクトするレスポンスが含まれていること" do
        expect(subject).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET #edit" do
    let!(:quest) { create(:public_quest, :tag_name_trip, user: user) }
    subject { response }

    context "ユーザーがログインしている場合" do
      before do
        sign_in user
        get edit_quest_path(quest)
      end

      it "editページのgetリクエストが成功していること" do
        expect(subject).to have_http_status(200)
      end

      it "フォームがレスポンスに含まれていること" do
        expect(response.body).to include "trip"
        expect(response.body).to include "クエストタイトル"
        expect(response.body).to include "Public quest"
        expect(response.body).to include "クエスト詳細"
        expect(response.body).to include "Public quest description"
        expect(response.body).to include "難易度"
        5.times do |num|
          expect(response.body).to include "id=\"radio-#{num + 1}\""
        end
        expect(response.body).to include "value=\"#{quest.difficulty}\" checked=\"checked\""
        expect(response.body).to include "value=\"1\" checked=\"checked\""
        expect(response.body).to include "クエストを公開する"
        expect(response.body).to include "type=\"submit\""
        expect(response.body).to include "更新"
      end

      context "存在しないquestにアクセスした場合" do
        before { get quest_path(0) }

        it "ステータスコード302（リダイレクト）がレスポンスされていること" do
          expect(subject).to have_http_status(302)
        end

        it "quest一覧ページにリダイレクトするレスポンスが含まれていること" do
          expect(subject).to redirect_to quests_path
        end
      end
    end

    context "ユーザーがログインしていない場合" do
      before { get edit_quest_path(quest) }
      it "ステータスコード302（リダイレクト）がレスポンスされていること" do
        expect(subject).to have_http_status(302)
      end

      it "sign_inページにリダイレクトするレスポンスが含まれていること" do
        expect(subject).to redirect_to new_user_session_path
      end
    end
  end

  describe "PATCH #update" do
    let!(:quest) { create(:public_quest, user: user) }
    subject { response }
    before { sign_in user }

    context "questの更新に成功する場合" do
      describe "レスポンス確認" do
        before do
          patch quest_path(quest), params: { quest_form: attributes_for(:other_quest_form) }
        end

        it "showページにリダイレクトされていること" do
          expect(subject).to redirect_to quest_path(quest)
        end

        it "ステータスコード302（リダイレクト）がレスポンスさていること" do
          expect(subject).to have_http_status(302)
        end
      end
    end

    context "questの更新に失敗する場合" do
      before do
        patch quest_path(quest), params: { quest_form: attributes_for(:non_correct_quest_form) }
      end

      it "ステータスコード302（リダイレクト）がレスポンスさていること" do
        expect(subject).to have_http_status(302)
      end

      it "quest編集ページにリダイレクトするレスポンスが含まれていること" do
        expect(subject).to redirect_to edit_quest_path(user.quests.last)
      end
    end

    context "存在しないquestを更新しようとした場合" do
      before do
        patch quest_path(0), params: { quest_form: attributes_for(:quest_form) }
      end

      it "ステータスコード302（リダイレクト）がレスポンスされていること" do
        expect(subject).to have_http_status(302)
      end

      it "quest一覧ページにリダイレクトするレスポンスが含まれていること" do
        expect(subject).to redirect_to quests_path
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:quest) { create(:non_public_quest, user: user) }
    let!(:public_quest) { create(:public_quest, user: user) }
    let!(:other_quest) { create(:public_other_quest, user: other_user) }

    subject { response }
    before { sign_in user }

    context "ユーザー自身のquestを削除する場合" do
      it "削除が成功した際に、quest数が減少していること" do
        expect do
          delete quest_path(quest)
        end.to change(Quest, :count).by(-1)
      end

      context "publicがfalseの場合" do
        before { delete quest_path(quest) }

        it "quest一覧ページにリダイレクトしていること" do
          expect(subject).to redirect_to my_quest_quests_path
        end
        it "ステータスコード302（リダイレクト）がレスポンスされていること" do
          expect(subject).to have_http_status(302)
        end
      end

      context "publicがtrueの場合" do
        before { delete quest_path(public_quest) }

        it "quest編集ページにリダイレクトしていること" do
          expect(subject).to redirect_to edit_quest_path
        end
        it "ステータスコード302（リダイレクト）がレスポンスされていること" do
          expect(subject).to have_http_status(302)
        end
      end
    end

    context "他ユーザーのquestを削除しようとした場合" do
      it "削除が失敗した際に、quest数が変化していないこと" do
        expect do
          delete quest_path(other_quest)
        end.to change(Quest, :count).by(0)
      end

      describe "レスポンス確認" do
        before { delete quest_path(other_quest) }

        it "quest一覧ページにリダイレクトしていること" do
          expect(subject).to redirect_to quests_path
        end

        it "ステータスコード302（リダイレクト）がレスポンスさていること" do
          expect(subject).to have_http_status(302)
        end
      end
    end

    context "存在しないquestを削除しようとした場合" do
      it "削除が失敗した際に、quest数が変化していないこと" do
        expect do
          delete quest_path(0)
        end.to change(Quest, :count).by(0)
      end

      describe "レスポンス確認" do
        before { delete quest_path(0) }

        it "ステータスコード302（リダイレクト）がレスポンスされていること" do
          expect(subject).to have_http_status(302)
        end

        it "quest一覧ページにリダイレクトするレスポンスが含まれていること" do
          expect(subject).to redirect_to quests_path
        end
      end
    end
  end
end
