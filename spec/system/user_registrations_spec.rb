require 'rails_helper'

RSpec.describe "UserRegistrations", type: :system do
  describe "表示確認" do
    before do
      visit new_user_registration_path
    end

    it "サインアップのフォームが表示されていること" do
      expect(page).to have_content "ユーザー名"
      expect(page).to have_content "メールアドレス"
      expect(page).to have_content "パスワード"
      expect(page).to have_content "確認用パスワード"
      expect(page).to have_content "Sign up"
      expect(page).to have_field "ユーザー名"
      expect(page).to have_field "メールアドレス"
      expect(page).to have_field "パスワード"
      expect(page).to have_field "確認用パスワード"
      expect(page).to have_button "Sign up"
    end
    # タイトルが〇〇となっていること
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
        click_on 'Sign up'
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
    # ロゴを押下することでホーム画面に遷移すること
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
        click_on 'Sign up'
      end

      # タイトルが〇〇となっていること
      it "登録完了後に〇〇ページに遷移していること" do
        expect(current_path).to eq pages_main_path
      end

      it "成功したフラッシュメッセージが表示されること" do
        expect(page).to have_content 'アカウント登録が完了しました。'
      end

      # サインアップ後、アプリのヘッダーにユーザー名が表示されていること
    end

    context "登録が失敗する場合" do
      context "登録情報が空である場合" do
        before do
          fill_in 'ユーザー名', with: ''
          fill_in 'メールアドレス', with: ''
          fill_in 'パスワード', with: ''
          fill_in '確認用パスワード', with: ''
          click_on 'Sign up'
        end

        # タイトルが〇〇となっていること

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

        # アプリのヘッダーにユーザー名が表示されていないこと
      end

      context "登録情報が不正な値である場合" do
        before do
          fill_in 'ユーザー名', with: 'sample user'
          fill_in 'メールアドレス', with: 'sample'
          fill_in 'パスワード', with: 'pass'
          fill_in '確認用パスワード', with: 'passs'
          click_on 'Sign up'
        end

        # タイトルが〇〇となっていること

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

        # アプリのヘッダーにユーザー名が表示されていないこと
      end

      context "登録情報のemailが重複している場合" do
        let!(:duplicate_user) { create(:duplicate_user) }
        before do
          fill_in 'メールアドレス', with: 'duplicate@mail.com'
          click_on 'Sign up'
        end

        # タイトルが〇〇となっていること

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

        # アプリのヘッダーにユーザー名が表示されていないこと
      end
    end
  end

  describe "ユーザー編集" do
  end

  describe "ユーザー削除" do
    let(:user) { create(:user) }
    before { sign_in user }

    it "退会に成功すること" do
      visit pages_withdraw_path
      click_on "ユーザー退会"
      expect(current_path).to eq root_path
      expect(page).to have_content "アカウントを削除しました。またのご利用をお待ちしております。"
    end
  end
  # 別タブで操作されている場合
end
