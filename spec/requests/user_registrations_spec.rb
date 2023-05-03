require 'rails_helper'

RSpec.describe "UserRegistrations", type: :request do
  describe "GET #new" do
    subject { response }

    it "ユーザー登録ページのgetリクエストが成功していること" do
      get new_user_registration_path
      expect(subject).to have_http_status(200)
    end
  end

  describe "POST #create" do
    subject { response }

    context "サインアップに成功する場合" do
      it "ユーザー数が増加していること" do
        expect do
          post user_registration_path, params: { user: attributes_for(:user) }
        end.to change(User, :count).by(1)
      end

      describe "レスポンス確認" do
        before { post user_registration_path, params: { user: attributes_for(:user) } }

        it "〇〇ページにリダイレクトされていること" do
          expect(subject).to redirect_to pages_main_path
        end

        it "ステータスコード303（リダイレクト）がレスポンスされていること" do
          expect(subject).to have_http_status(303)
        end

        it "許可されているページにアクセスした際、ステータスコード200がレスポンスされていること" do
          get pages_main_path
          expect(subject).to have_http_status(200)
        end
      end

      # サインアップした場合に表示されるヘッダーのレスポンスが含まれていること
    end

    context "サインアップに失敗する場合" do
      it "ユーザー数が変化していないこと" do
        expect do
          post user_registration_path, params: { user: attributes_for(:non_correct_user) }
        end.to change(User, :count).by(0)
      end

      describe "レスポンス確認" do
        before { post user_registration_path, params: { user: attributes_for(:non_correct_user) } }

        it "ステータスコード422(バリデーションエラー)がレスポンスされていること" do
          expect(subject).to have_http_status(422)
        end

        it "許可されていないページにアクセスした際、ステータスコード302（リダイレクト）がレスポンスされていること" do
          get pages_main_path
          expect(subject).to have_http_status(302)
        end
      end
    end
  end

  describe "GET #edit" do
    let(:user) { create(:user) }
    subject { response }

    context "ユーザーがログインしている場合" do
      before do
        sign_in user
        get edit_user_registration_path
      end

      it "ユーザー編集ページのgetリクエストが成功していること" do
        get edit_user_registration_path
        expect(subject).to have_http_status(200)
      end

      it "フォームがレスポンスに含まれること" do
        expect(response.body).to include "ユーザー名"
        expect(response.body).to include "メールアドレス"
        expect(response.body).to include "パスワード"
        expect(response.body).to include "確認用パスワード"
        expect(response.body).to include "現在のパスワード"
      end
    end

    context "ユーザーがログインしていない場合" do
      before { get edit_user_registration_path }

      it "ステータスコード302（リダイレクト）がレスポンスされていること" do
        expect(subject).to have_http_status(302)
      end

      it "sign_inページにリダイレクトするレスポンスが含まれていること" do
        expect(subject).to redirect_to new_user_session_path
      end
    end
  end

  describe "PATCH #update" do
    let(:user) { create(:user) }
    subject { response }
    before { sign_in user }

    context "userの更新に成功する場合" do
      before do
        user_params = {
          name: "サンプルユーザー",
          email: "correct@mail.com",
          password: "password",
          password_confirmation: "password",
          current_password: "samplepassword",
        }
        patch user_registration_path, params: { user: user_params }
      end

      it "users/profileページにリダイレクトされていること" do
        expect(subject).to redirect_to pages_profile_path
      end

      it "ステータスコード302（リダイレクト）がレスポンスさていること" do
        expect(subject).to have_http_status(303)
      end
    end

    context "userの更新に失敗する場合" do
      context "入力内容が空である場合" do
        before do
          user_params = {
            name: "",
            email: "",
            password: "",
            password_confirmation: "",
            current_password: "",
          }
          patch user_registration_path, params: { user: user_params }
        end

        it "ステータスコード422(バリデーションエラー)がレスポンスされていること" do
          expect(subject).to have_http_status(422)
        end

        it "フラッシュメッセージがレスポンスに含まれていること" do
          expect(response.body).to include "ユーザー名を入力してください"
          expect(response.body).to include "メールアドレスを入力してください"
          expect(response.body).to include "6文字以上のパスワードを入力してください。"
          expect(response.body).to include "現在のパスワードを入力してください"
        end
      end

      context "変更しようとしているメールアドレスが他ユーザーと重複している場合" do
        let!(:other_user) { create(:correct_user) }
        before do
          user_params = {
            email: "correct@mail.com",
            current_password: "samplepassword",
          }
          patch user_registration_path, params: { user: user_params }
        end

        it "ステータスコード422(バリデーションエラー)がレスポンスされていること" do
          expect(subject).to have_http_status(422)
        end

        it "フラッシュメッセージがレスポンスに含まれていること" do
          expect(response.body).to include "メールアドレスはすでに存在します"
        end
      end
    end
  end

  describe "DELETE #destroy" do
    subject { response }
    before { post user_registration_path, params: { user: attributes_for(:user) } }

    it "ユーザー削除に成功した際にユーザー数が減少していること" do
      expect do
        delete user_registration_path
      end.to change(User, :count).by(-1)
    end

    describe "レスポンス確認" do
      before { delete user_registration_path }

      it "登録削除に成功しルートページにリダイレクトされていること" do
        expect(subject).to redirect_to root_path
      end

      it "登録削除に成功しステータスコード303（リダイレクト）がレスポンスされていること" do
        expect(subject).to have_http_status(303)
      end
    end
  end
end
