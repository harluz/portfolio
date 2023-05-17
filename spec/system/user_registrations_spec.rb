require 'rails_helper'

RSpec.describe "UserRegistrations", type: :system do
  describe "表示確認" do
    context "users/new" do
      before do
        visit new_user_registration_path
      end

      it "タイトルが「新規登録  | BranChannel」になっていること" do
        expect(page).to have_title "新規登録 | BranChannel"
      end

      it "新規登録のフォームが表示されていること" do
        expect(page).to have_content "ユーザー名"
        expect(page).to have_content "メールアドレス"
        expect(page).to have_content "パスワード"
        expect(page).to have_content "確認用パスワード"
        expect(page).to have_content "登録"
        expect(page).to have_field "ユーザー名"
        expect(page).to have_field "メールアドレス"
        expect(page).to have_field "パスワード"
        expect(page).to have_field "確認用パスワード"
        expect(page).to have_button "登録"
        expect(page).to have_link "キャンセル"
      end
    end

    context "users/edit" do
      let(:user) { create(:user) }
      before do
        sign_in user
        visit edit_user_registration_path
      end

      it "タイトルが「ユーザー編集 | BranChannel」になっていること" do
        expect(page).to have_title "ユーザー編集 | BranChannel"
      end

      it "編集のフォームが表示されていること" do
        expect(page).to have_content "ユーザー名"
        expect(page).to have_content "メールアドレス"
        expect(page).to have_content "パスワード (変更する場合のみ)"
        expect(page).to have_content "確認用パスワード"
        expect(page).to have_content "現在のパスワード"
        expect(page).to have_field "ユーザー名"
        expect(page).to have_field "メールアドレス"
        expect(page).to have_field "パスワード"
        expect(page).to have_field "確認用パスワード"
        expect(page).to have_field "現在のパスワード"
        expect(page).to have_button "更新"
        expect(page).to have_link "キャンセル"
        expect(page).to have_link "退会についてはこちら"
      end
    end
  end

  describe "ページ遷移確認" do
    before do
      visit new_user_registration_path
    end

    context "登録済みユーザーが再度サインアップページにアクセスした場合" do
      before do
        fill_in 'ユーザー名', with: 'sample user'
        fill_in 'メールアドレス', with: 'sample@mail.com'
        fill_in 'パスワード', with: 'password'
        fill_in '確認用パスワード', with: 'password'
        click_on '登録'
        visit new_user_registration_path
      end

      it "ルートページに遷移し、登録済みであることが分かるフラッシュメッセージが表示されること" do
        expect(current_path).to eq root_path
        expect(page).to have_content 'すでにログインしています。'
      end

      it "リダイレクト後にページをリロードすることでフラッシュメッセージが消えること" do
        visit current_path
        expect(page).not_to have_content 'すでにログインしています。'
      end
    end
  end

  describe "ユーザー新規登録" do
    before do
      visit new_user_registration_path
    end

    context "登録が成功する場合" do
      before do
        fill_in 'ユーザー名', with: 'sample user'
        fill_in 'メールアドレス', with: 'sample@mail.com'
        fill_in 'パスワード', with: 'password'
        fill_in '確認用パスワード', with: 'password'
        click_on '登録'
      end

      it "登録完了後にクエスト一覧ページに遷移していること" do
        expect(current_path).to eq quests_path
      end

      it "成功したフラッシュメッセージが表示されること" do
        expect(page).to have_content 'アカウント登録が完了しました。'
      end
    end

    context "登録が失敗する場合" do
      context "登録情報が空である場合" do
        before do
          fill_in 'ユーザー名', with: ''
          fill_in 'メールアドレス', with: ''
          fill_in 'パスワード', with: ''
          fill_in '確認用パスワード', with: ''
          click_on '登録'
        end

        it "登録失敗時に/usersがrenderされていること" do
          expect(current_path).to eq user_registration_path
        end

        it "サインアップに失敗したとき、エラーメッセージが表示されていること" do
          expect(page).to have_content 'ユーザー名を入力してください'
          expect(page).to have_content 'メールアドレスを入力してください'
          expect(page).to have_content 'パスワードを入力してください'
        end

        it "サインアップに失敗したとき、エラーメッセージが表示されリロードすると表示が消えること" do
          visit current_path
          expect(page).not_to have_content 'メールアドレスは不正な値です'
          expect(page).not_to have_content 'パスワードは6文字以上で入力してください'
          expect(page).not_to have_content '確認用パスワードとパスワードの入力が一致しません'
        end
      end

      context "登録情報が不正な値である場合" do
        before do
          fill_in 'ユーザー名', with: 'sample user'
          fill_in 'メールアドレス', with: 'sample'
          fill_in 'パスワード', with: 'pass'
          fill_in '確認用パスワード', with: 'passs'
          click_on '登録'
        end

        it "登録失敗時に/usersがrenderされていること" do
          expect(current_path).to eq user_registration_path
        end

        it "サインアップに失敗したとき、エラーメッセージが表示されていること" do
          expect(page).to have_content 'メールアドレスは不正な値です'
          expect(page).to have_content 'パスワードは6文字以上で入力してください'
          expect(page).to have_content '確認用パスワードとパスワードの入力が一致しません'
        end

        it "サインアップに失敗したとき、エラーメッセージが表示されリロードすると表示が消えること" do
          visit current_path
          expect(page).not_to have_content 'メールアドレスは不正な値です'
          expect(page).not_to have_content 'パスワードは6文字以上で入力してください'
          expect(page).not_to have_content '確認用パスワードとパスワードの入力が一致しません'
        end
      end

      context "登録情報のemailが重複している場合" do
        let!(:duplicate_user) { create(:duplicate_user) }
        before do
          fill_in 'メールアドレス', with: 'duplicate@mail.com'
          click_on '登録'
        end

        it "登録失敗時に/usersがrenderされていること" do
          expect(current_path).to eq user_registration_path
        end

        it "サインアップに失敗したとき、エラーメッセージが表示されていること" do
          expect(page).to have_content 'メールアドレスはすでに存在します'
        end

        it "サインアップに失敗したとき、エラーメッセージが表示されリロードすると表示が消えること" do
          visit current_path
          expect(page).not_to have_content 'メールアドレスはすでに存在します'
        end
      end
    end
  end

  describe "ユーザー編集" do
    let(:user) { create(:user) }
    let!(:noticer) { create(:noticer) }
    before { sign_in user }

    context "更新に成功する場合" do
      before do
        visit edit_user_registration_path
        fill_in 'ユーザー名', with: "サンプルユーザー"
        fill_in 'メールアドレス', with: "samplemail@mail.com"
        fill_in 'パスワード', with: "password"
        fill_in '確認用パスワード', with: "password"
        fill_in '現在のパスワード', with: "samplepassword"
        click_on '更新'
      end

      it "profileページに遷移していること" do
        expect(current_path).to eq pages_profile_path
      end

      it "フラッシュメッセージが表示されていること" do
        expect(page).to have_content "アカウント情報を変更しました。"
      end

      it "変更後のユーザー名が表示されていること" do
        expect(page).to have_content "サンプルユーザー"
      end

      it "リロードした際にフラッシュメッセージが消えていること" do
        visit current_path
        expect(page).not_to have_content "アカウント情報を変更しました。"
      end
    end

    context "更新に失敗する場合" do
      let!(:other_user) { create(:correct_user) }
      before do
        visit edit_user_registration_path
        fill_in 'ユーザー名', with: ""
        fill_in 'メールアドレス', with: ""
        fill_in 'パスワード', with: ""
        fill_in '確認用パスワード', with: ""
        fill_in '現在のパスワード', with: ""
        click_on '更新'
      end

      it "フラッシュメッセージが表示されていること" do
        expect(page).to have_content "ユーザー名を入力してください"
        expect(page).to have_content "メールアドレスを入力してください"
        expect(page).to have_content "現在のパスワードを入力してください"
        fill_in 'メールアドレス', with: "correct@mail.com"
        fill_in 'パスワード', with: "pass"
        fill_in '確認用パスワード', with: "path"
        fill_in '現在のパスワード', with: "pathword"
        click_on '更新'
        expect(page).to have_content "メールアドレスはすでに存在します"
        expect(page).to have_content "パスワードは6文字以上で入力してください"
        expect(page).to have_content "確認用パスワードとパスワードの入力が一致しません"
        expect(page).to have_content "現在のパスワードは不正な値です"
      end

      it "/users/editページに遷移していること" do
        expect(current_path).to eq user_registration_path
      end

      it "リロードした際にフラッシュメッセージが消えていること" do
        visit current_path
        expect(page).not_to have_content "ユーザー名を入力してください"
        expect(page).not_to have_content "メールアドレスを入力してください"
        expect(page).not_to have_content "6文字以上のパスワードを入力してください。"
        expect(page).not_to have_content "現在のパスワードを入力してください"
      end
    end
  end

  describe "ユーザー削除" do
    let(:user) { create(:user) }
    before { sign_in user }

    it "退会に成功すること" do
      visit edit_user_registration_path
      click_on "退会についてはこちら"
      click_on "ユーザー退会"
      expect(current_path).to eq root_path
      expect(page).to have_content "アカウントを削除しました。またのご利用をお待ちしております。"
    end
  end
  # 別タブで操作されている場合
end
