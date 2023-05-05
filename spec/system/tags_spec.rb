require 'rails_helper'

RSpec.describe "Tags", type: :system do
  let!(:user) { create(:user) }
  before { sign_in user }

  describe "tag新規作成" do
    before do
      visit new_quest_path
      fill_in 'タイトル', with: "Create a quest you want to complete."
      fill_in 'クエスト詳細', with: "Create quest achievement conditions."
      choose('quest_difficulty_3')
    end

    it "タグが未入力の場合、タグが表示されないこと" do
      fill_in "quest[tag_name]", with: ''
      click_on "クエスト作成！"
      expect(current_path).to eq quest_path(user.quests.last)
      expect(page).not_to have_content user.quests.last.tags.all
    end

    it "同一クエスト内でタグが重複している場合、重複が削除されタグが表示されていること" do
      fill_in "quest[tag_name]", with: '旅行 旅行 食べ物'
      click_on "クエスト作成！"
      expect(current_path).to eq quest_path(user.quests.last)
      expect(page).to have_link "#旅行"
      expect(page).to have_link "#食べ物"
    end

    it "タグの先頭が半角スペースが入力されていても、正常に保存され表示されていること" do
      fill_in "quest[tag_name]", with: ' 旅行 食べ物'
      click_on "クエスト作成！"
      expect(current_path).to eq quest_path(user.quests.last)
      expect(page).to have_link "#旅行"
      expect(page).to have_link "#食べ物"
    end

    it "タグの先頭が全角スペースが入力されていても、正常に保存され表示されていること" do
      fill_in "quest[tag_name]", with: '　旅行 食べ物'
      click_on "クエスト作成！"
      expect(current_path).to eq quest_path(user.quests.last)
      expect(page).to have_link "#旅行"
      expect(page).to have_link "#食べ物"
    end

    it "タグ同士のスペースが全角スペースであっても、正常に保存され表示されていること" do
      fill_in "quest[tag_name]", with: '旅行　食べ物'
      click_on "クエスト作成！"
      expect(current_path).to eq quest_path(user.quests.last)
      expect(page).to have_link "#旅行"
      expect(page).to have_link "#食べ物"
    end

    it "タグの末尾に半角スペースがあっても、正常に保存され表示されていること" do
      fill_in "quest[tag_name]", with: '旅行 食べ物 '
      click_on "クエスト作成！"
      expect(current_path).to eq quest_path(user.quests.last)
      expect(page).to have_link "#旅行"
      expect(page).to have_link "#食べ物"
    end

    it "タグの末尾に全角スペースがあっても、正常に保存され表示されていること" do
      fill_in "quest[tag_name]", with: '旅行 食べ物　'
      click_on "クエスト作成！"
      expect(current_path).to eq quest_path(user.quests.last)
      expect(page).to have_link "#旅行"
      expect(page).to have_link "#食べ物"
    end
  end

  describe "tag編集" do
    before do
      visit new_quest_path
      fill_in 'タイトル', with: "Create a quest you want to complete."
      fill_in 'クエスト詳細', with: "Create quest achievement conditions."
      choose('quest_difficulty_3')
      fill_in "quest[tag_name]", with: 'trip'
      click_on "クエスト作成！"
      visit edit_quest_path(user.quests.last)
    end

    it "既存のタグフォーム内に表示されていること" do
      expect(page.body).to include "input value=\"trip\""
    end

    it "タグを追加することができること" do
      fill_in "quest[tag_name]", with: "trip travel"
      click_on "更新"
      expect(current_path).to eq quest_path(user.quests.last)
      expect(page).to have_link "#trip"
      expect(page).to have_link "#travel"
    end

    it "既にあるタグを変更することができる" do
      fill_in "quest[tag_name]", with: "travel"
      click_on "更新"
      expect(current_path).to eq quest_path(user.quests.last)
      expect(page).not_to have_link "#trip"
      expect(page).to have_link "#travel"
    end

    it "タグが重複しても、重複は削除されエラーが発生せず変更することができる" do
      fill_in "quest[tag_name]", with: "trip trip"
      click_on "更新"
      expect(current_path).to eq quest_path(user.quests.last)
      expect(page).to have_link "#trip"
    end

    it "タグを削除することができる" do
      fill_in "quest[tag_name]", with: ""
      click_on "更新"
      expect(current_path).to eq quest_path(user.quests.last)
      expect(page).not_to have_content "#trip"
    end
  end
end
