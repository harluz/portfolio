require 'rails_helper'

RSpec.describe "Tags", type: :system do
  let!(:user) { create(:user) }
  before { sign_in user }

  describe "表示確認" do
    context "/quests/new" do
      before do
        visit new_quest_path
      end

      it "タグのフォームが表示されていること" do
        expect(page).to have_content "タグ"
        expect(page).to have_field "タグ"
      end
    end

    context "/quests/edit" do
      let!(:quest) { create(:quest, user: user) }
      before do
        visit edit_quest_path(quest)
      end

      it "タグのフォームが表示されていること" do
        expect(page).to have_content "タグ"
        expect(page).to have_field "タグ"
      end
    end
  end

  describe "tag新規作成" do
    context "クエストの作成に成功する場合" do
      before do
        visit new_quest_path
        fill_in 'クエストタイトル', with: "Create a quest you want to complete."
        fill_in 'クエスト詳細', with: "Create quest achievement conditions."
        choose('radio-3')
      end

      it "タグが未入力の場合、タグが表示されないこと" do
        fill_in "quest_form_name", with: ''
        click_on "クエスト作成"
        expect(current_path).to eq quest_path(user.quests.last)
        expect(page).not_to have_content user.quests.last.tags.all
      end
  
      it "同一クエスト内でタグが重複している場合、重複が削除されタグが表示されていること" do
        fill_in "quest_form_name", with: '旅行 旅行 食べ物'
        click_on "クエスト作成"
        expect(current_path).to eq quest_path(user.quests.last)
        expect(page).to have_link "#旅行"
        expect(page).to have_link "#食べ物"
      end
  
      it "タグの先頭が半角スペースが入力されていても、正常に保存され表示されていること" do
        fill_in "quest_form_name", with: ' 旅行 食べ物'
        click_on "クエスト作成"
        expect(current_path).to eq quest_path(user.quests.last)
        expect(page).to have_link "#旅行"
        expect(page).to have_link "#食べ物"
      end
  
      it "タグの先頭が全角スペースが入力されていても、正常に保存され表示されていること" do
        fill_in "quest_form_name", with: '　旅行 食べ物'
        click_on "クエスト作成"
        expect(current_path).to eq quest_path(user.quests.last)
        expect(page).to have_link "#旅行"
        expect(page).to have_link "#食べ物"
      end
  
      it "タグ同士のスペースが全角スペースであっても、正常に保存され表示されていること" do
        fill_in "quest_form_name", with: '旅行　食べ物'
        click_on "クエスト作成"
        expect(current_path).to eq quest_path(user.quests.last)
        expect(page).to have_link "#旅行"
        expect(page).to have_link "#食べ物"
      end
  
      it "タグの末尾に半角スペースがあっても、正常に保存され表示されていること" do
        fill_in "quest_form_name", with: '旅行 食べ物 '
        click_on "クエスト作成"
        expect(current_path).to eq quest_path(user.quests.last)
        expect(page).to have_link "#旅行"
        expect(page).to have_link "#食べ物"
      end
  
      it "タグの末尾に全角スペースがあっても、正常に保存され表示されていること" do
        fill_in "quest_form_name", with: '旅行 食べ物　'
        click_on "クエスト作成"
        expect(current_path).to eq quest_path(user.quests.last)
        expect(page).to have_link "#旅行"
        expect(page).to have_link "#食べ物"
      end
    end

    context "クエストの作成に失敗する場合" do
      before do
        visit new_quest_path
        fill_in 'クエストタイトル', with: ""
        fill_in 'クエスト詳細', with: "Create quest achievement conditions."
        choose('radio-3')
      end

      it "失敗後のリダイレクトが実行されても、フォームにタグの値が保持されていること" do
        fill_in "quest_form_name", with: '旅行 食べ物'
        click_on "クエスト作成"
        expect(current_path).to eq new_quest_path
        expect(page).to have_xpath("//input[@value='旅行 食べ物']")
      end

      it "リロードしてもフォームにタグの値が保持されていること" do
        visit current_path
        fill_in "quest_form_name", with: '旅行 食べ物'
        click_on "クエスト作成"
        expect(current_path).to eq new_quest_path
        expect(page).to have_xpath("//input[@value='旅行 食べ物']")
      end

      it "別ページに遷移後、再度newページにアクセスした場合、タグのフォームの中身は空となっていること" do
        visit quests_path
        visit new_quest_path
        expect(page).not_to have_xpath("//input[@value='旅行 食べ物']")
      end
    end
  end

  describe "tag編集" do
    before do
      visit new_quest_path
      fill_in 'クエストタイトル', with: "Create a quest you want to complete."
      fill_in 'クエスト詳細', with: "Create quest achievement conditions."
      choose('radio-3')
      fill_in "quest_form_name", with: 'trip'
      click_on "クエスト作成"
      visit edit_quest_path(user.quests.last)
    end

    context "クエストの更新に成功する場合" do
      it "既存のタグフォーム内に表示されていること" do
        expect(page.body).to include "value=\"trip\""
      end
  
      it "タグを追加することができること" do
        fill_in "quest_form_name", with: "trip travel"
        click_on "更新"
        expect(current_path).to eq quest_path(user.quests.last)
        expect(page).to have_link "#trip"
        expect(page).to have_link "#travel"
      end
  
      it "既にあるタグを変更することができる" do
        fill_in "quest_form_name", with: "travel"
        click_on "更新"
        expect(current_path).to eq quest_path(user.quests.last)
        expect(page).not_to have_link "#trip"
        expect(page).to have_link "#travel"
      end
  
      it "タグが重複しても、重複は削除されエラーが発生せず変更することができる" do
        fill_in "quest_form_name", with: "trip trip"
        click_on "更新"
        expect(current_path).to eq quest_path(user.quests.last)
        expect(page).to have_link "#trip"
      end
  
      it "タグを削除することができる" do
        fill_in "quest_form_name", with: ""
        click_on "更新"
        expect(current_path).to eq quest_path(user.quests.last)
        expect(page).not_to have_content "#trip"
      end
    end

    context "クエストの更新に失敗する場合" do
      it "タグの変更なしの場合は当初のタグがフォームの値に保持されていること" do
        fill_in 'クエストタイトル', with: ""
        fill_in "quest_form_name", with: "trip"
        click_on "更新"
        expect(current_path).to eq edit_quest_path(user.quests.last)
        expect(page).to have_xpath("//input[@value='trip']")
      end

      it "タグの追加を行なった場合は追加分のタグもフォームの値に保持されていること" do
        fill_in 'クエストタイトル', with: ""
        fill_in "quest_form_name", with: "trip travel"
        click_on "更新"
        expect(current_path).to eq edit_quest_path(user.quests.last)
        expect(page).to have_xpath("//input[@value='trip travel']")
      end

      it "タグを削除した場合はフォームの値が空となっていること" do
        fill_in 'クエストタイトル', with: ""
        fill_in "quest_form_name", with: ""
        click_on "更新"
        expect(current_path).to eq edit_quest_path(user.quests.last)
        expect(page).not_to have_xpath("//input[@value='trip']")
      end

      it "リロードしてもフォームの値が保持さていること" do
        fill_in 'クエストタイトル', with: ""
        fill_in "quest_form_name", with: "trip travel"
        click_on "更新"
        visit current_path
        expect(current_path).to eq edit_quest_path(user.quests.last)
        expect(page).to have_xpath("//input[@value='trip travel']")
      end

      it "別ページに移動後、再度editページにアクセスした場合、フォームの中身は元のタグの値となっていること" do
        fill_in 'クエストタイトル', with: ""
        fill_in "quest_form_name", with: "trip travel"
        click_on "更新"
        visit quests_path
        visit edit_quest_path(user.quests.last)
        expect(current_path).to eq edit_quest_path(user.quests.last)
        expect(page).to have_xpath("//input[@value='trip']")
        expect(page).not_to have_xpath("//input[@value='trip travel']")
      end
    end
  end
end
