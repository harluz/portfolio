require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  describe "表示確認" do
    before do
      visit new_user_session_path
    end

    it "ログインのフォームが表示されていること" do
      expect(page).to have_content "メールアドレス"
      expect(page).to have_content "パスワード"
      expect(page).to have_content "Remember me"
      expect(page).to have_content "Log in"
      expect(page).to have_field "メールアドレス"
      expect(page).to have_field "パスワード"
      expect(page).to have_unchecked_field "Remember me"
      expect(page).to have_button "Log in"
    end
    # タイトルが〇〇となっていること
  end

  describe "ページ遷移確認" do
    let!(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    context "ログイン済みユーザーが再度ログインページにアクセスした場合" do
      before do
        fill_in 'メールアドレス', with: 'sample@mail.com'
        fill_in 'パスワード', with: 'samplepassword'
        click_on 'Log in'
        visit new_user_session_path
      end

      it "メインページに遷移し、ログイン済みであることが分かるフラッシュメッセージが表示されること" do
        expect(current_path).to eq pages_main_path
        expect(page).to have_content 'すでにログインしています。'
      end

      it "リダイレクト後にページをリロードすることでフラッシュメッセージが消えること" do
        visit current_path
        expect(page).not_to have_content 'すでにログインしています。'
      end
    end
    # ロゴを押下することでホーム画面に遷移すること
  end

  describe "ログイン確認" do
    let!(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    context "ログインが成功する場合" do
      before do
        fill_in 'メールアドレス', with: 'sample@mail.com'
        fill_in 'パスワード', with: 'samplepassword'
        click_on 'Log in'
      end

      it "ログイン後に〇〇ページに遷移していること" do
        expect(current_path).to eq pages_main_path
      end

      it "成功したフラッシュメッセージが表示されること" do
        expect(page).to have_content 'ログインしました。'
      end

      it "ログインに成功したとき、成功したフラッシュメッセージが表示されリロードすると表示が消えること" do
        visit current_path
        expect(page).not_to have_content 'ログインしました。'
      end

      # タイトルが〇〇となっていること
      # ログイン後、アプリのヘッダーにユーザー名が表示されていること
    end

    context "ログインが失敗する場合" do
      before do
        fill_in 'メールアドレス', with: 'sample'
        fill_in 'パスワード', with: 'sample'
        click_on 'Log in'
      end

      it "〇〇ページに遷移していること" do
        expect(current_path).to eq new_user_session_path
      end

      it "失敗したフラッシュメッセージが表示されること" do
        expect(page).to have_content 'メールアドレス もしくはパスワードが不正です。'
      end

      it "ログインに失敗したとき、失敗したフラッシュメッセージが表示されリロードすると表示が消えること" do
        visit current_path
        expect(page).not_to have_content 'メールアドレス もしくはパスワードが不正です。'
      end

      # タイトルが〇〇となっていること
      # ログイン後、アプリのヘッダーにユーザー名が表示されていないこと
    end
  end

  describe "ゲストログイン確認" do
    before do
      visit root_path
      click_on "ゲストログイン"
    end

    it "ログイン後に〇〇ページに遷移していること" do
      expect(current_path).to eq root_path
    end

    it "成功したフラッシュメッセージが表示されること" do
      expect(page).to have_content 'ゲストユーザーとしてログインしました。'
    end

    it "ログインに成功したとき、成功したフラッシュメッセージが表示されリロードすると表示が消えること" do
      visit current_path
      expect(page).not_to have_content 'ゲストユーザーとしてログインしました。'
    end
  end

  describe "ログアウト確認" do
    let(:user) { create(:user) }
    before do
      sign_in user
      visit root_path
      click_on "ログアウト"
    end

    it "ログアウト後にルートページに遷移していること" do
      expect(current_path).to eq root_path
    end

    it "成功したフラッシュメッセージが表示されること" do
      expect(page).to have_content 'ログアウトしました。'
    end

    it "ログアウト後にログインするリンクが表示されていること" do
      expect(page).to have_content "ログイン"
    end

    it "ログインに成功したとき、成功したフラッシュメッセージが表示されリロードすると表示が消えること" do
      visit current_path
      expect(page).not_to have_content 'ログアウトしました。'
    end
  end
end
