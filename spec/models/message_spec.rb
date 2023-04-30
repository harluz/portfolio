require 'rails_helper'

RSpec.describe Message, type: :model do
  describe "バリデーション確認" do
    let(:user) { create(:user) }
    let(:quest) { create(:quest, user: user) }
    let(:room) { create(:room, quest: quest) }
    let(:message) { build(:message, user: user, room: room) }

    it "content,user_id,room_idがある場合、有効である" do
      expect(message).to be_valid
    end

    it "contentがない場合、無効である" do
      message.content = nil
      message.valid?
      expect(message.errors[:content]).to include("を入力してください")
    end

    it "user_idがない場合、無効である" do
      message.user_id = nil
      message.valid?
      expect(message.errors[:user_id]).to include("を入力してください")
    end
    it "room_idがない場合、無効である" do
      message.room_id = nil
      message.valid?
      expect(message.errors[:room_id]).to include("を入力してください")
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

    context "roomとのリレーション" do
      let(:model) { :room }

      it "roomとの関連付けはbelongs_toであること" do
        expect(association.macro).to eq :belongs_to
      end
    end
  end
end
