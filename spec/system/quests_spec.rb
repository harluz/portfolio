require 'rails_helper'

RSpec.describe "Quests", type: :system do
  let(:user) { create(:user) }
  before { sign_in user }

  describe "表示確認" do
    context "/quests/new" do
      before do
        visit new_quest_path
      end

      it "クエスト作成のフォームが表示されていること" do
        expect(page).to have_content "タイトル"
        expect(page).to have_content "クエスト詳細"
        expect(page).to have_content "難易度"
        expect(page).to have_content "クエストを公開する"
        expect(page).to have_content "キャンセル"
        expect(page).to have_field "タイトル"
        expect(page).to have_field "クエスト詳細"
        expect(page).to have_unchecked_field "quest_public"
        expect(page).to have_link "キャンセル"
        expect(page).to have_button "クエスト作成！"
      end

      it "ラジオボタンのチェックが動作していること" do
        expect(page).to have_checked_field with: "1"
        choose('quest_difficulty_2')
        expect(page).to have_checked_field with: "2"
        choose('quest_difficulty_3')
        expect(page).to have_checked_field with: "3"
        choose('quest_difficulty_4')
        expect(page).to have_checked_field with: "4"
        choose('quest_difficulty_5')
        expect(page).to have_checked_field with: "5"
      end

      it "チェックボックスが動作していること" do
        check "quest_public"
        expect(page).to have_checked_field "quest_public"
        uncheck "quest_public"
        expect(page).to have_unchecked_field "quest_public"
      end
      # 　タイトルが〇〇となっていること
    end

    context "/quests/show" do
      let(:quest) { create(:quest, user: user) }
      before do
        visit quest_path(quest)
      end

      it "作成したquestの情報が表示されていること" do
        expect(page).to have_content "Create a quest you want to complete."
        expect(page).to have_content "Create quest achievement conditions."
        expect(page).to have_content "3"
        expect(page).to have_content "6 ポイント"
      end
      # 　タイトルが〇〇となっていること
    end

    context "/quests/edit" do
    end
  end

  describe "ページ遷移確認" do
  end

  describe "クエスト新規作成" do
    let(:quest) { create(:quest, user: user) }
    before do
      visit new_quest_path
    end

    context "作成に成功する場合" do
      before do
        fill_in 'タイトル', with: "Create a quest you want to complete."
        fill_in 'クエスト詳細', with: "Create quest achievement conditions."
        choose('quest_difficulty_3')
        check "quest_public"
        click_on "クエスト作成！"
      end

      it "showページに遷移していること" do
        expect(current_path).to eq quest_path(user.quests.last)
      end

      it "成功したフラッシュメッセージが表示されていること" do
        expect(page).to have_content 'BranChannelに新たなクエストが作成されました。'
      end

      it "showページでquestの情報が表示されていること" do
        expect(page).to have_content "Create a quest you want to complete."
        expect(page).to have_content "Create quest achievement conditions."
        expect(page).to have_content "3"
        expect(page).to have_content "6 ポイント"
        expect(page).to have_content "このクエストは公開されています。"
      end

      it "リロードした際に成功したフラッシュメッセージが消えていること" do
        visit quest_path(quest)
        expect(page).not_to have_content 'BranChannelに新たなクエストが作成されました。'
      end
    end

    context "作成に失敗する場合" do
      before do
        fill_in 'タイトル', with: ""
        fill_in 'クエスト詳細', with: "string being input"
        choose('quest_difficulty_4')
        check "quest_public"
        click_on "クエスト作成！"
      end

      it "newページに遷移していること" do
        expect(current_path).to eq new_quest_path
      end

      it "失敗したエラー・フラッシュメッセージ、入力中のクエスト詳細が表示されていること" do
        expect(page).to have_content "クエストの作成に失敗しました。"
        expect(page).to have_content "タイトルを入力してください"
        expect(page).to have_content "string being input"
        expect(page).to have_checked_field with: "4"
        expect(page).to have_checked_field "quest_public"
      end

      it "リロードした際にエラー・フラッシュメッセージは消え、フォームの値は保持されていること" do
        visit new_quest_path
        expect(page).not_to have_content "クエストの作成に失敗しました。"
        expect(page).not_to have_content "タイトルを入力してください"
        expect(page).to have_content "string being input"
        expect(page).to have_checked_field with: "4"
        expect(page).to have_checked_field "quest_public"
      end
    end
  end

  describe "クエスト編集" do
  end

  describe "クエスト削除" do
  end
end
