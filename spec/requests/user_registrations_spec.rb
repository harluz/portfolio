require 'rails_helper'

RSpec.describe "UserRegistrations", type: :request do
  describe "#new" do
    it "ユーザー登録ページのgetリクエストが成功していること" do
      get new_user_registration_path
      expect(response).to have_http_status(200)
    end
  end

  describe "#create" do
    describe "サインアップに成功する場合" do
      it "ユーザー数が増加していること" do
        expect do
          post user_registration_path, params: { user: attributes_for(:user) }
        end.to change(User, :count).by(1)
      end

      describe "レスポンス確認" do
        before { post user_registration_path, params: { user: attributes_for(:user) } }

        it "〇〇ページにリダイレクトされていること" do
          expect(response).to redirect_to pages_main_path
        end

        it "ステータスコード303（リダイレクト）がレスポンスされていること" do
          expect(response).to have_http_status(303)
        end

        it "許可されているページにアクセスした際、ステータスコード200がレスポンスされていること" do
          get pages_main_path
          expect(response).to have_http_status(200)
        end
      end

      # 許可されたページにアクセスした際、ステータスコード200（）がレスポンスされていること
      # サインアップした場合に表示されるヘッダーのレスポンスが含まれていること
    end

    describe "サインアップに失敗する場合" do
      it "ユーザー数が変化していないこと" do
        expect do
          post user_registration_path, params: { user: attributes_for(:non_correct_user) }
        end.to change(User, :count).by(0)
      end

      describe "レスポンス確認" do
        before { post user_registration_path, params: { user: attributes_for(:non_correct_user) } }

        it "ステータスコード422(バリデーションエラー)がレスポンスされていること" do
          expect(response).to have_http_status(422)
        end

        it "許可されていないページにアクセスした際、ステータスコード302（リダイレクト）がレスポンスされていること" do
          get pages_main_path
          expect(response).to have_http_status(302)
        end
      end
    end
  end

  describe "#destroy" do
    it "ユーザー削除に成功した際にユーザー数が減少していること" do
      expect do
        delete user_registration_path
      end.to change(User, :count).by(-1)
    end

    before { post user_registration_path, params: { user: attributes_for(:user) } }
    it "登録削除に成功しルートページにリダイレクトされていること" do
      delete user_registration_path
      expect(response).to redirect_to root_path
    end

    it "登録削除に成功しステータスコード303（リダイレクト）がレスポンスされていること" do
      delete user_registration_path
      expect(response).to have_http_status(303)
    end
  end
end
