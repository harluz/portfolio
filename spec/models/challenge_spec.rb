require 'rails_helper'

RSpec.describe Challenge, type: :model do
  describe "バリデーション確認" do
    let(:user) { create(:user) }
    let(:quest) { create(:quest, user: user) }
    let!(:challenge) { build(:challenge, user_id: user.id, quest_id: quest.id) }

    it "user_id,quest_idがある場合、有効である" do
      expect(challenge).to be_valid
    end

    it "user_idがない場合、無効である" do
      challenge.user_id = nil
      challenge.valid?
      expect(challenge.errors[:user_id]).to include("を入力してください")
    end

    it "quest_idがない場合、無効である" do
      challenge.quest_id = nil
      challenge.valid?
      expect(challenge.errors[:quest_id]).to include("を入力してください")
    end

    it "closeがない場合、無効である" do
      challenge.close = nil
      challenge.valid?
      expect(challenge.errors[:close]).to include("は一覧にありません")
    end
  end

  describe "リレーション確認" do
    let!(:association) do
      described_class.reflect_on_association(model)
    end

    context "userとのリレーション" do
      let(:model) { :user }

      it "userとの関連付けはhas_manyであること" do
        expect(association.macro).to eq :belongs_to
      end
    end

    context "challengesとのリレーション" do
      let(:model) { :quest }

      it "challengeとの関連付けはhas_manyであること" do
        expect(association.macro).to eq :belongs_to
      end
    end
  end
end
