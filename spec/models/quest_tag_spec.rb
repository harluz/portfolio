require 'rails_helper'

RSpec.describe QuestTag, type: :model do
  describe "リレーション確認" do
    let!(:association) do
      described_class.reflect_on_association(model)
    end

    context "questとのリレーション" do
      let(:model) { :quest }

      it "questとの関連付けはbelongs_toであること" do
        expect(association.macro).to eq :belongs_to
      end
    end

    context "tagとのリレーション" do
      let(:model) { :tag }

      it "tagとの関連付けはbelongs_toであること" do
        expect(association.macro).to eq :belongs_to
      end
    end
  end
end
