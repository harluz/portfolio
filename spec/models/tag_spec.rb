require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe "リレーション確認" do
    let!(:association) do
      described_class.reflect_on_association(model)
    end

    context "quest_tagとのリレーション" do
      let(:model) { :quest_tags }

      it "quest_tagとの関連付けはhas_manyであること" do
        expect(association.macro).to eq :has_many
      end
    end

    context "questとのリレーション" do
      let(:model) { :quests }

      it "quest_tagとの関連付けはhas_manyであること" do
        expect(association.macro).to eq :has_many
      end
    end
  end
end
