require 'rails_helper'

RSpec.describe "Quests", type: :system do
  let!(:user) { create(:user) }
  before { sign_in user }

  describe "表示確認" do
    context "/quests/index" do
      context "ユーザー自身が作成したクエストの場合" do
        let!(:quest) { create(:quest, user: user) }
        it "リンクが正しく表示・非表示となっていること" do
          visit quests_path
          expect(page).to have_content "編集する"
          expect(page).to have_content "削除する"
          quest.public = true
          quest.save
          visit quests_path
          expect(page).not_to have_content "削除する"
        end
      end

      context "他ユーザーが作成したクエストの場合" do
        let!(:other_user) { create(:correct_user) }
        let!(:other_quest) { create(:other_quest, user: other_user) }
        it "編集及び削除リンクが表示されていないこと" do
          visit quests_path
          expect(page).not_to have_content "編集する"
          expect(page).not_to have_content "削除する"
          other_quest.public = true
          other_quest.save
          visit quests_path
          expect(page).not_to have_content "削除する"
        end
      end
      # public:falseとなっているものだけを表示
    end

    context "/quests/my_quest" do
      context "作成したクエストがある場合" do
        let(:other_user) { create(:correct_user) }
        let!(:quest) { create(:quest, user: user) }
        let!(:other_public_quest) { create(:public_other_quest, user: other_user) }
        it "クエストが表示されていること" do
          visit my_quest_quests_path
          expect(page).to have_content quest.title
          expect(page).not_to have_content other_public_quest.title
        end
        it "リンクが正しく表示・非表示となっていること" do
          visit my_quest_quests_path
          expect(page).to have_content "詳細"
          expect(page).to have_content "編集する"
          expect(page).to have_content "削除する"
          quest.public = true
          quest.save
          visit my_quest_quests_path
          expect(page).not_to have_content "削除する"
        end
      end
      context "作成したクエストがない場合" do
        it "クエストがないメッセージが表示されること" do
          visit my_quest_quests_path
          expect(page).to have_content "作成したクエストがありません"
        end
      end
    end

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

      context "存在するデータを表示する場合" do
        it "作成したquestの情報が表示されていること" do
          expect(page).to have_content "Create a quest you want to complete."
          expect(page).to have_content "Create quest achievement conditions."
          expect(page).to have_content "3"
          expect(page).to have_content "6 ポイント"
        end
        # 　タイトルが〇〇となっていること
      end
      context "存在しないデータにアクセスする場合" do
        it "indexページにリダイレクトし、エラーメッセージが表示されていること" do
          visit quest_path(10000)
          expect(current_path).to eq quests_path
          expect(page).to have_content "クエストが存在していません。"
        end
      end
      # questのshowページにクエストが公開されている、かつ自分のクエストでなく、かつ既に挑戦中でないクエストに「挑戦する」リンクが表示されていること
    end

    context "/quests/edit" do
      let!(:quest) { create(:quest, user: user) }
      before do
        visit edit_quest_path(quest)
      end
      it "クエスト更新のフォームが表示されていること" do
        expect(page).to have_content "タイトル"
        expect(page).to have_content "クエスト詳細"
        expect(page).to have_content "難易度"
        expect(page).to have_content "クエストを公開する"
        expect(page).to have_content "キャンセル"
        expect(page).to have_field "タイトル"
        expect(page).to have_field "クエスト詳細"
        expect(page).to have_unchecked_field "quest_public"
        expect(page).to have_link "キャンセル"
        expect(page).to have_button "更新"
      end
      it "フォームにquestの値が表示されていること" do
        expect(page).to have_xpath("//input[@value='Create a quest you want to complete.']")
        expect(page).to have_content "Create quest achievement conditions."
        expect(page).to have_checked_field with: "3"
        expect(page).to have_unchecked_field "quest_public"
      end
      context "存在しないデータにアクセスする場合" do
        it "indexページにリダイレクトし、エラーメッセージが表示されていること" do
          visit edit_quest_path(10000)
          expect(current_path).to eq quests_path
          expect(page).to have_content "クエストが存在していません。"
        end
      end
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
        expect(page).to have_xpath("//input[@value='']")
        expect(page).to have_content "タイトルを入力してください"
        expect(page).to have_content "string being input"
        expect(page).to have_checked_field with: "4"
        expect(page).to have_checked_field "quest_public"
      end

      it "リロードした際にエラー・フラッシュメッセージは消え、フォームの値は保持されていること" do
        visit new_quest_path
        expect(page).not_to have_content "クエストの作成に失敗しました。"
        expect(page).to have_xpath("//input[@value='']")
        expect(page).not_to have_content "タイトルを入力してください"
        expect(page).to have_content "string being input"
        expect(page).to have_checked_field with: "4"
        expect(page).to have_checked_field "quest_public"
      end
    end
  end

  describe "クエスト編集" do
    let!(:quest) { create(:quest, user: user) }
    before do
      visit edit_quest_path(quest)
    end
    context "更新に成功する場合" do
      before do
        fill_in 'タイトル', with: "updated quest"
        fill_in 'クエスト詳細', with: "Update quest achievement conditions."
        choose('quest_difficulty_2')
        uncheck "quest_public"
        click_on "更新"
      end

      it "showページに遷移していること" do
        expect(current_path).to eq quest_path(quest)
      end

      it "成功したフラッシュメッセージが表示されていること" do
        expect(page).to have_content 'クエストを更新しました。'
      end

      it "showページでquestの情報が表示されていること" do
        expect(page).to have_content "updated quest"
        expect(page).to have_content "Update quest achievement conditions."
        expect(page).to have_content "2"
        expect(page).to have_content "4 ポイント"
        expect(page).to have_content "このクエストは公開されていません。"
      end
    end
    context "更新に失敗する場合" do
      before do
        fill_in 'タイトル', with: ""
        fill_in 'クエスト詳細', with: "Update quest achievement conditions."
        choose('quest_difficulty_2')
        uncheck "quest_public"
        click_on "更新"
      end

      it "showページに遷移していること" do
        expect(current_path).to eq quest_path(quest)
      end

      it "失敗したフラッシュメッセージが表示されていること" do
        expect(page).to have_content 'クエストの更新に失敗しました。'
      end

      it "showページでquestの情報が表示されていること" do
        expect(page).to have_xpath("//input[@value='']")
        expect(page).to have_content "Update quest achievement conditions."
        expect(page).to have_checked_field with: "2"
        expect(page).to have_unchecked_field "quest_public"
      end

      it "render後にリロードすることで更新前のquestが表示されていること" do
        visit quest_path(quest)
        expect(page).to have_content "Create a quest you want to complete."
        expect(page).to have_content "Create quest achievement conditions."
        expect(page).to have_content "3"
        expect(page).to have_content "6 ポイント"
        expect(page).to have_content "このクエストは公開されていません。"
      end
    end
    context "他のユーザーが作成したクエストを編集しようとした場合" do
      let!(:other_user) { create(:correct_user) }
      let!(:other_quest) { create(:other_quest, user: other_user) }

      before do
        visit edit_quest_path(other_quest)
      end

      it "indexページにリダレクトし、エラーのフラッシュメッセージが表示されていること" do
        expect(current_path).to eq quests_path
        expect(page).to have_content "他のユーザーのクエストを操作することはできません。"
      end
    end
  end

  describe "クエスト削除" do
    let!(:quest) { create(:quest, user: user) }
    before do
      visit quests_path
    end
    context "削除に成功する場合" do
      before do
        click_on "削除する"
      end

      it "indexページに遷移していること" do
        expect(current_path).to eq quests_path
      end

      it "成功したフラッシュメッセージが表示されていること" do
        expect(page).to have_content "クエストが削除されました。"
      end

      it "削除したクエストが表示されていないこと" do
        expect(page).not_to have_content "Create a quest you want to complete."
      end
    end
    # 削除に失敗する場合
  end
end
