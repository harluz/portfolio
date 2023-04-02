require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:duplicate_user) { create(:duplicate_user) }
  let(:correct_user) { build(:correct_user) }
  let(:non_correct_user) { build(:non_correct_user) }
  let(:duplicate_user2) { build(:duplicate_user) }

  describe "バリデーションのテスト" do
    it "ユーザーの情報が有効であること" do
      expect(correct_user).to be_valid
    end

    it "ユーザーの情報が無効であること" do
      expect(non_correct_user).not_to be_valid
    end

    it "ユーザーのemailが登録済みのemailと重複していることから無効であること" do
      expect(duplicate_user2).not_to be_valid
    end
  end
  # describe "アソシエーションのテスト" do
  # end
end
