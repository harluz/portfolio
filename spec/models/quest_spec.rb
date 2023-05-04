require 'rails_helper'

RSpec.describe Quest, type: :model do
  describe "バリデーション確認" do
    let(:user) { create(:user) }
    let(:quest) { build(:quest, user: user) }

    it "title,describe,difficulty,xp,publicがある場合、有効である" do
      expect(quest).to be_valid
    end

    it "titleがない場合、無効である" do
      quest.title = nil
      quest.valid?
      expect(quest.errors[:title]).to include("を入力してください")
    end

    it "difficultyがない場合、無効である" do
      quest.difficulty = nil
      quest.valid?
      expect(quest.errors[:difficulty]).to include("を入力してください")
    end

    it "difficultyが数字でない場合、無効である" do
      quest.difficulty = "easy"
      quest.valid?
      expect(quest.errors[:difficulty]).to include("は数値で入力してください")
    end

    it "difficultyが整数でない場合、無効である" do
      quest.difficulty = 0.1
      quest.valid?
      expect(quest.errors[:difficulty]).to include("は整数で入力してください")
    end

    it "difficultyが0である場合、無効である" do
      quest.difficulty = 0
      quest.valid?
      expect(quest.errors[:difficulty]).to include("は1以上の値にしてください")
    end

    it "difficultyが5より大きい場合場合、無効である" do
      quest.difficulty = 6
      quest.valid?
      expect(quest.errors[:difficulty]).to include("は5以下の値にしてください")
    end

    it "xpがない場合、無効である" do
      quest.xp = nil
      quest.valid?
      expect(quest.errors[:xp]).to include("を入力してください")
    end

    it "xpが数字でない場合、無効である" do
      quest.xp = "1point"
      quest.valid?
      expect(quest.errors[:xp]).to include("は数値で入力してください")
    end

    it "xpが整数でない場合、無効である" do
      quest.xp = 0.1
      quest.valid?
      expect(quest.errors[:xp]).to include("は整数で入力してください")
    end

    it "publicがない場合、無効である" do
      quest.public = nil
      quest.valid?
      expect(quest.errors[:public]).to include("は一覧にありません")
    end

    it "user_idがない場合、無効である" do
      quest.user_id = nil
      quest.valid?
      expect(quest.errors[:user_id]).to include("を入力してください")
    end
  end

  describe "リレーション確認" do
    let!(:association) do
      described_class.reflect_on_association(model)
    end

    context "userとのリレーション" do
      let(:model) { :user }

      it "userとの関連付けはbelongs_toであること" do
        expect(association.macro).to eq :belongs_to
      end
    end

    context "challengeとのリレーション" do
      let(:model) { :challenges }

      it "challengeとの関連付けはhas_manyであること" do
        expect(association.macro).to eq :has_many
      end
    end

    context "roomとのリレーション" do
      let(:model) { :room }

      it "roomとの関連付けはhas_manyであること" do
        expect(association.macro).to eq :has_one
      end
    end

    context "quest_tagとのリレーション" do
      let(:model) { :quest_tags }

      it "quest_tagとの関連付けはhas_manyであること" do
        expect(association.macro).to eq :has_many
      end
    end

    context "tagとのリレーション" do
      let(:model) { :tags }

      it "tagとの関連付けはhas_manyであること" do
        expect(association.macro).to eq :has_many
      end
    end
  end
end
