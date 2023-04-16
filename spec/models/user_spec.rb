require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:duplicate_user) { create(:duplicate_user) }
  let(:correct_user) { build(:correct_user) }
  let(:non_correct_user) { build(:non_correct_user) }
  let(:duplicate_user2) { build(:duplicate_user) }

  describe "バリデーション確認" do
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

  describe "リレーション確認" do
    let!(:association) do
      described_class.reflect_on_association(model)
    end

    context "questとのリレーション" do
      let(:model) { :quests }

      it "questとの関連付けはhas_manyであること" do
        expect(association.macro).to eq :has_many
      end
    end

    context "challengesとのリレーション" do
      let(:model) { :challenges }

      it "challengeとの関連付けはhas_manyであること" do
        expect(association.macro).to eq :has_many
      end
    end
  end
end
