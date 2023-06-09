require 'rails_helper'

RSpec.describe "Quests", type: :system do
  let!(:user) { create(:user) }
  before { sign_in user }

  describe "表示確認" do
    context "/quests/index" do
      it "クエスト一覧 | BranChannel」になっていること" do
        visit quests_path
        expect(page).to have_title "クエスト一覧 | BranChannel"
      end

      context "ユーザー自身が作成したクエストの場合" do
        let!(:public_quest) { create(:public_quest, user: user) }
        it "リンクが正しく表示・非表示となっていること" do
          visit quests_path
          expect(page).to have_field "search"
          expect(page).to have_button "検索"
          expect(page).to have_content "詳細"
          public_quest.public = false
          public_quest.save
          visit quests_path
        end
      end

      context "他ユーザーが作成したクエストの場合" do
        let(:other_user) { create(:correct_user) }
        let!(:public_other_quest) { create(:public_other_quest, user: other_user) }
        it "詳細及び編集リンクが表示されていないこと" do
          visit quests_path
          expect(page).to have_field "search"
          expect(page).to have_button "検索"
          expect(page).to have_content "詳細"
          public_other_quest.public = false
          public_other_quest.save
          visit quests_path
        end
      end

      context "キーワード検索を行なった場合" do
        let(:other_user) { create(:correct_user) }
        let!(:public_quest1) { create(:public_quest, user: user, title: "sample sentence") }
        let!(:public_quest2) { create(:public_quest, user: user, title: "keyword search") }
        let!(:public_quest3) { create(:public_quest, user: other_user, title: "sample quest") }
        let!(:non_public_quest1) { create(:non_public_quest, user: user, title: "sample input") }
        let!(:non_public_quest2) { create(:non_public_quest, user: other_user, title: "sample hoge") }

        before { visit quests_path }

        it "キーワードに関連した公開クエストが表示されること" do
          fill_in "search", with: "sample"
          click_on "検索"
          expect(current_path).to eq quests_path
          expect(page).to have_content "sample sentence"
          expect(page).to have_content "sample quest"
          expect(page).not_to have_content "keyword search"
          expect(page).not_to have_content "sample input"
          expect(page).not_to have_content "sampla hoge"
        end

        it "あいまい検索が機能し、関連した公開クエストが表示されること" do
          fill_in "search", with: "samp"
          click_on "検索"
          expect(current_path).to eq quests_path
          expect(page).to have_content "sample sentence"
          expect(page).to have_content "sample quest"
          expect(page).not_to have_content "keyword search"
          expect(page).not_to have_content "sample input"
          expect(page).not_to have_content "sampla hoge"
        end

        it "検索フォームが空の状態で検索をクリックした際は、すべての公開クエストが表示されること" do
          fill_in "search", with: ""
          click_on "検索"
          expect(current_path).to eq quests_path
          expect(page).to have_content "sample sentence"
          expect(page).to have_content "sample quest"
          expect(page).to have_content "keyword search"
          expect(page).not_to have_content "sample input"
          expect(page).not_to have_content "sampla hoge"
        end

        it "キーワードが合致しなかった場合、クエストが表示されないこと" do
          fill_in "search", with: "example"
          click_on "検索"
          expect(current_path).to eq quests_path
          expect(page).not_to have_content "sample sentence"
          expect(page).not_to have_content "sample quest"
          expect(page).not_to have_content "keyword search"
          expect(page).not_to have_content "sample input"
          expect(page).not_to have_content "sampla hoge"
        end

        it "複数ワードで検索した場合、最初の単語に関連した公開クエストが表示されること" do
          fill_in "search", with: "sample keyword"
          click_on "検索"
          expect(current_path).to eq quests_path
          expect(page).to have_content "sample sentence"
          expect(page).to have_content "sample quest"
          expect(page).not_to have_content "keyword search"
          expect(page).not_to have_content "sample input"
          expect(page).not_to have_content "sampla hoge"
        end

        it "キーワードの先頭にスペースがあった場合、スペース後の単語に関連した公開クエストが表示されること" do
          fill_in "search", with: " sample"
          click_on "検索"
          expect(current_path).to eq quests_path
          expect(page).to have_content "sample sentence"
          expect(page).to have_content "sample quest"
          expect(page).not_to have_content "keyword search"
          expect(page).not_to have_content "sample input"
          expect(page).not_to have_content "sampla hoge"
        end
      end

      context "タグ検索が行われた場合" do
        let(:other_user) { create(:correct_user) }
        let!(:public_quest1) { create(:public_quest, :tag_name_trip, user: user, title: "sample sentence") }
        let!(:public_quest2) { create(:public_quest, :tag_name_sports, user: user, title: "keyword search") }
        let!(:public_quest3) { create(:public_quest, :tag_name_hobby, user: other_user, title: "sample quest") }
        let!(:non_public_quest1) { create(:non_public_quest, user: user, title: "sample input") }
        let!(:non_public_quest2) { create(:non_public_quest, user: other_user, title: "sample hoge") }
        let!(:room) { create(:room, quest: public_quest1) }
        let!(:room2) { create(:room, quest: public_quest2) }

        before { visit quests_path }

        it "検索フォームで入力されたタグに関連した公開クエストが表示されること" do
          visit edit_quest_path(public_quest2)
          fill_in "quest_form_name", with: "sports trip"
          click_on "更新"
          visit quests_path
          fill_in "search", with: "#trip"
          click_on "検索"
          expect(current_path).to eq quests_path
          expect(page).to have_content "sample sentence"
          expect(page).to have_content "keyword search"
          expect(page).not_to have_content "sample quest"
          expect(page).not_to have_content "sample input"
          expect(page).not_to have_content "sampla hoge"
        end

        it "複数タグを検索フォームに入力した場合、最初のタグに関連した公開クエストが表示されること" do
          fill_in "search", with: "#sports #hobby"
          click_on "検索"
          expect(current_path).to eq quests_path
          expect(page).to have_content "keyword search"
          expect(page).not_to have_content "sample sentence"
          expect(page).not_to have_content "sample quest"
          expect(page).not_to have_content "sample input"
          expect(page).not_to have_content "sampla hoge"
        end

        it "#のみを検索フォームに入力した場合、すべての公開クエストが表示されること" do
          fill_in "search", with: "#"
          click_on "検索"
          expect(current_path).to eq quests_path
          expect(page).to have_content "keyword search"
          expect(page).to have_content "sample sentence"
          expect(page).to have_content "sample quest"
          expect(page).not_to have_content "sample input"
          expect(page).not_to have_content "sampla hoge"
        end

        it "questのshowページからタグリンクによる検索の場合、関連したクエストが表示されること" do
          visit quest_path(public_quest1)
          click_on "#trip"
          expect(current_path).to eq quests_path
          expect(page).to have_content "sample sentence"
          expect(page).not_to have_content "sample quest"
          expect(page).not_to have_content "keyword search"
          expect(page).not_to have_content "sample input"
          expect(page).not_to have_content "sampla hoge"
        end
      end
    end

    context "/quests/my_quest" do
      it "タイトルが「作成一覧 | BranChannel」になっていること" do
        visit my_quest_quests_path
        expect(page).to have_title "作成一覧 | BranChannel"
      end

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
          expect(page).to have_content "編集"
          expect(page).to have_content "削除"
          quest.public = true
          quest.save
          visit my_quest_quests_path
          expect(page).not_to have_content "削除"
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

      it "タイトルが「クエスト作成 | BranChannel」になっていること" do
        expect(page).to have_title "クエスト作成 | BranChannel"
      end

      it "クエスト作成のフォームが表示されていること" do
        expect(page).to have_content "タイトル"
        expect(page).to have_content "クエスト詳細"
        expect(page).to have_content "難易度"
        expect(page).to have_content "クエストを公開する"
        expect(page).to have_content "キャンセル"
        expect(page).to have_field "タイトル"
        expect(page).to have_field "クエスト詳細"
        expect(page).to have_unchecked_field "quest_form[public]"
        expect(page).to have_link "キャンセル"
        expect(page).to have_button "クエスト作成"
      end

      it "ラジオボタンのチェックが動作していること" do
        expect(page).to have_checked_field with: "1"
        choose('radio-2')
        expect(page).to have_checked_field with: "2"
        choose('radio-3')
        expect(page).to have_checked_field with: "3"
        choose('radio-4')
        expect(page).to have_checked_field with: "4"
        choose('radio-5')
        expect(page).to have_checked_field with: "5"
      end

      it "チェックボックスが動作していること" do
        check "quest_form[public]"
        expect(page).to have_checked_field "quest_form[public]"
        uncheck "quest_form[public]"
        expect(page).to have_unchecked_field "quest_form[public]"
      end
    end

    context "/quests/show" do
      let(:other_user) { create(:correct_user) }
      let(:quest) { create(:quest, user: user) }
      let(:other_quest) { create(:public_other_quest, user: other_user) }
      let!(:room) { create(:room, quest: quest) }
      let!(:other_room) { create(:room, quest: other_quest) }
      let!(:noticer) { create(:noticer) }
      let!(:discoverer) { create(:discoverer) }

      before do
        visit quest_path(quest)
      end

      it "タイトルが「クエスト詳細  | BranChannel」になっていること" do
        expect(page).to have_title "クエスト詳細 | BranChannel"
      end

      context "存在するデータを表示する場合" do
        it "作成したquestの情報が表示されていること" do
          expect(page).to have_content "Create a quest you want to complete."
          expect(page).to have_content "Create quest achievement conditions."
          expect(page).to have_content "3"
          expect(page).to have_content "クエスト非公開"
          expect(page).to have_link "トークルームへ"
          expect(page).to have_link "編集"
        end
      end

      context "存在しないデータにアクセスする場合" do
        it "indexページにリダイレクトし、エラーメッセージが表示されていること" do
          visit quest_path(0)
          expect(current_path).to eq quests_path
          expect(page).to have_content "クエストが存在していません。"
        end
      end

      context "他のユーザーの公開クエストにアクセスした場合" do
        it "挑戦するリンクが表示されること" do
          visit quest_path(other_quest)
          expect(page).to have_content "Public other quest"
          expect(page).to have_content "Public other quest description"
          expect(page).to have_content "4"
          expect(page).to have_content "クエスト公開中"
          expect(page).to have_link "トークルームへ"
          expect(page).to have_selector('a', text: '挑戦')
          expect(page).not_to have_link "編集"
        end

        it "挑戦中である場合は、挑戦するリンクが表示されないこと" do
          visit quest_path(other_quest)
          click_on "挑戦"
          visit quest_path(other_quest)
          expect(page).to have_content "Public other quest"
          expect(page).to have_content "Public other quest description"
          expect(page).to have_content "4"
          expect(page).to have_content "クエスト公開中"
          expect(page).to have_link "トークルームへ"
          expect(page).not_to have_link("挑戦", href: '挑戦')
          expect(page).not_to have_link "編集"
        end

        it "挑戦後に諦めたクエストに挑戦するリンクが表示されること" do
          visit quest_path(other_quest)
          click_on "挑戦"
          visit challenges_path
          click_on "諦める"
          visit quest_path(other_quest)
          expect(page).to have_selector('a', text: '挑戦')
        end

        it "挑戦後に達成したクエストは挑戦するリンクがふくまれていないこと" do
          visit quest_path(other_quest)
          click_on "挑戦"
          visit challenges_path
          click_on "達成"
          visit quest_path(other_quest)
          expect(page).not_to have_link("挑戦", href: '挑戦')
        end
      end
    end

    context "/quests/edit" do
      let!(:quest) { create(:quest, user: user) }
      before do
        visit edit_quest_path(quest)
      end

      it "タイトルが「クエスト編集  | BranChannel」になっていること" do
        expect(page).to have_title "クエスト編集 | BranChannel"
      end

      it "クエスト更新のフォームが表示されていること" do
        expect(page).to have_content "タイトル"
        expect(page).to have_content "クエスト詳細"
        expect(page).to have_content "難易度"
        expect(page).to have_content "クエストを公開する"
        expect(page).to have_content "キャンセル"
        expect(page).to have_field "タイトル"
        expect(page).to have_field "クエスト詳細"
        expect(page).to have_unchecked_field "quest_form[public]"
        expect(page).to have_link "キャンセル"
        expect(page).to have_button "更新"
      end

      it "フォームにquestの値が表示されていること" do
        expect(page).to have_xpath("//input[@value='Create a quest you want to complete.']")
        expect(page).to have_content "Create quest achievement conditions."
        expect(page).to have_checked_field with: "3"
        expect(page).to have_unchecked_field "quest_form[public]"
      end

      context "存在しないデータにアクセスする場合" do
        it "indexページにリダイレクトし、エラーメッセージが表示されていること" do
          visit edit_quest_path(0)
          expect(current_path).to eq quests_path
          expect(page).to have_content "クエストが存在していません。"
        end
      end
    end
  end

  describe "クエスト新規作成" do
    let(:quest) { create(:quest, user: user) }
    let!(:room) { create(:room, quest: quest) }
    before do
      visit new_quest_path
    end

    context "作成に成功する場合" do
      before do
        fill_in 'タイトル', with: "Create a quest you want to complete."
        fill_in 'クエスト詳細', with: "Create quest achievement conditions."
        choose('radio-3')
        check "quest_form[public]"
        click_on "クエスト作成"
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
        expect(page).to have_content "クエスト公開中"
        expect(page).to have_link "トークルームへ"
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
        choose('radio-4')
        check "quest_form[public]"
        click_on "クエスト作成"
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
        expect(page).to have_checked_field "quest_form[public]"
      end

      it "リロードした際にエラー・フラッシュメッセージは消え、フォームの値は保持されていること" do
        visit current_path
        expect(page).not_to have_content "クエストの作成に失敗しました。"
        expect(page).to have_xpath("//input[@value='']")
        expect(page).not_to have_content "タイトルを入力してください"
        expect(page).to have_content "string being input"
        expect(page).to have_checked_field with: "4"
        expect(page).to have_checked_field "quest_form[public]"
      end

      it "別ページに移動後、再度newページにアクセスした場合、フォームの中身は空となっていること" do
        visit quests_path
        visit new_quest_path
        expect(page).not_to have_xpath("//input[@value='']")
        expect(page).not_to have_content "タイトルを入力してください"
        expect(page).not_to have_content "string being input"
        expect(page).not_to have_checked_field with: "4"
        expect(page).not_to have_checked_field "quest_form[public]"
      end
    end
  end

  describe "クエスト編集" do
    let!(:quest) { create(:quest, user: user) }
    let!(:room) { create(:room, quest: quest) }
    before do
      visit edit_quest_path(quest)
    end

    context "更新に成功する場合" do
      before do
        fill_in 'タイトル', with: "updated quest"
        fill_in 'クエスト詳細', with: "Update quest achievement conditions."
        choose('radio-2')
        check "quest_form[public]"
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
        expect(page).to have_content "クエスト公開中"
        expect(page).to have_link "トークルームへ"
      end
    end

    context "更新に失敗する場合" do
      before do
        fill_in 'タイトル', with: ""
        fill_in 'クエスト詳細', with: "Update quest achievement conditions."
        choose('radio-2')
        check "quest_form[public]"
        click_on "更新"
      end

      it "クエスト編集ページに遷移していること" do
        expect(current_path).to eq edit_quest_path(quest)
      end

      it "失敗したフラッシュメッセージが表示されていること" do
        expect(page).to have_content 'クエストの更新に失敗しました。'
        expect(page).to have_content 'クエストタイトルを入力してください'
      end

      it "クエスト編集ページでquestの情報が表示されていること" do
        expect(page).to have_xpath("//input[@value='']")
        expect(page).to have_content "Update quest achievement conditions."
        expect(page).to have_checked_field with: "2"
        expect(page).to have_checked_field "quest_form[public]"
      end

      it "リダイレクト後にリロードすることで更新前のquestが表示されていること" do
        visit current_path
        expect(page).not_to have_content 'クエストの更新に失敗しました。'
        expect(page).not_to have_content 'クエストタイトルを入力してください'
        expect(page).to have_xpath("//input[@value='']")
        expect(page).to have_content "Update quest achievement conditions."
        expect(page).to have_checked_field with: "2"
        expect(page).to have_checked_field "quest_form[public]"
      end

      it "別ページに移動後、再度editページにアクセスした場合、フォームに元のクエストの値が保持されていること" do
        visit quests_path
        visit edit_quest_path(quest)
        expect(page).to have_xpath("//input[@value='Create a quest you want to complete.']")
        expect(page).to have_content "Create quest achievement conditions."
        expect(page).to have_checked_field with: "3"
        expect(page).to have_unchecked_field "quest_form[public]"
        expect(page).not_to have_xpath("//input[@value='']")
        expect(page).not_to have_content "Update quest achievement conditions."
        expect(page).not_to have_checked_field with: "2"
        expect(page).not_to have_checked_field "quest_form[public]"
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
      visit my_quest_quests_path
    end

    context "削除に成功する場合" do
      before do
        click_on "削除"
      end

      it "indexページに遷移していること" do
        expect(current_path).to eq my_quest_quests_path
      end

      it "成功したフラッシュメッセージが表示されていること" do
        expect(page).to have_content "クエストが削除されました。"
      end

      it "削除したクエストが表示されていないこと" do
        expect(page).not_to have_content "Create a quest you want to complete."
      end
    end
  end
end
