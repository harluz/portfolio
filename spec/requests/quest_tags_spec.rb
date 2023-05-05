require 'rails_helper'

RSpec.describe "QuestTags", type: :request do
  let!(:user) { create(:user) }
  let!(:non_public_quest1) { create(:non_public_quest, user: user) }
  let!(:non_public_quest2) { create(:non_public_quest, :tag_name_trip, user: user) }
  let!(:non_public_quest3) { create(:other_quest, user: user) }

  before { sign_in user }

  describe "DELETE #destroy" do
    it "クエストを削除した際に、quest_tagが減少していること" do
      expect do
        delete quest_path(non_public_quest1)
      end.to change(QuestTag, :count).by(-1)
    end

    it "複数タグがあるクエストを削除した際、タグの数だけquest_tagが減少していること" do
      expect do
        delete quest_path(non_public_quest2)
      end.to change(QuestTag, :count).by(-2)
    end

    it "タグのないクエストを削除した際、quest_tagの数は変化しないこと" do
      expect do
        delete quest_path(non_public_quest3)
      end.to change(QuestTag, :count).by(0)
    end
  end
end
