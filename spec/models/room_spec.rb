require 'rails_helper'

RSpec.describe Room, type: :model do
  describe "バリデーション確認" do
    let(:user) { create(:user) }
    let(:quest) { create(:quest, user: user) }
    let(:room) { build(:room, quest: quest) }
    let(:message) { build(:message, user: user, room: room) }
  
    it "quest_idがある場合、有効である" do
      expect(room).to be_valid
    end

    it "quest_idがない場合、無効である" do
      room.quest_id = nil
      room.valid?
      expect(room.errors[:quest_id]).to include("を入力してください")
    end
  end

  describe "リレーション確認" do
    let!(:association) do
      described_class.reflect_on_association(model)
    end

    context "questとのリレーション" do
      let(:model) { :quest }

      it "userとの関連付けはbelongs_toであること" do
        expect(association.macro).to eq :belongs_to
      end
    end

    context "messageとのリレーション" do
      let(:model) { :messages }

      it "roomとの関連付けはbelongs_toであること" do
        expect(association.macro).to eq :has_many
      end
    end
  end
end
