require 'rails_helper'

RSpec.describe "Tags", type: :request do
  let!(:user) { create(:user) }

  before { sign_in user }

  describe "POST #create" do
    quest_add_tag_params = {
      title: "quest title",
      describe: "quest describe",
      difficulty: 1,
      xp: 2,
      public: false,
      tag_name: "クエストタグ"
    }

    context "tagの作成に成功すること" do
      it "tagの数が増加していること" do
        expect do
          post quests_path, params: { quest: quest_add_tag_params }
        end.to change(Tag, :count).by(1)
      end

      it "tagが空である場合、tagの数が増加していないこと" do
        quest_add_tag_params[:tag_name] = ""
        expect do
          post quests_path, params: { quest: quest_add_tag_params }
        end.to change(Tag, :count).by(0)
      end

      it "追加されたtagの分だけ数が増加していること" do
        quest_add_tag_params[:tag_name] = "旅行 食べ物"
        expect do
          post quests_path, params: { quest: quest_add_tag_params }
        end.to change(Tag, :count).by(2)
      end

      it "tagが重複する場合、重複が除かれtagの数が増加していること" do
        quest_add_tag_params[:tag_name] = "旅行 旅行"
        expect do
          post quests_path, params: { quest: quest_add_tag_params }
        end.to change(Tag, :count).by(1)
      end

      it "tagの先頭に半角スペースが含まれている場合、tagの数が増加していること" do
        quest_add_tag_params[:tag_name] = " 旅行"
        expect do
          post quests_path, params: { quest: quest_add_tag_params }
        end.to change(Tag, :count).by(1)
      end

      it "tagの先頭に全角スペースが含まれている場合、tagの数が増加していること" do
        quest_add_tag_params[:tag_name] = "　旅行"
        expect do
          post quests_path, params: { quest: quest_add_tag_params }
        end.to change(Tag, :count).by(1)
      end

      it "タグ同士のスペースが全角スペースである場合、tagの数が増加していること" do
        quest_add_tag_params[:tag_name] = "旅行　食べ物"
        expect do
          post quests_path, params: { quest: quest_add_tag_params }
        end.to change(Tag, :count).by(2)
      end

      it "タグの末尾に半角スペースがある場合、tagの数が増加していること" do
        quest_add_tag_params[:tag_name] = "旅行 食べ物 "
        expect do
          post quests_path, params: { quest: quest_add_tag_params }
        end.to change(Tag, :count).by(2)
      end

      it "タグの末尾に全角スペースがある場合、tagの数が増加していること" do
        quest_add_tag_params[:tag_name] = "旅行 食べ物　"
        expect do
          post quests_path, params: { quest: quest_add_tag_params }
        end.to change(Tag, :count).by(2)
      end
    end
  end

  describe "PATCH #update" do
    let!(:public_quest1) { create(:public_quest, :tag_name_trip, user: user, title: "sample sentence") }
    let!(:public_quest2) { create(:public_quest, :tag_name_sports, user: user, title: "keyword search") }
    let!(:room) { create(:room, quest: public_quest1) }
    quest_change_tag_params = {
      title: "quest title",
      describe: "quest describe",
      difficulty: 1,
      xp: 2,
      public: false,
      tag_name: "travel"
    }

    it "新しいタグが追加された場合、tagの数が増加すること" do
      expect do
        patch quest_path(public_quest1), params: { quest: quest_change_tag_params }
      end.to change(Tag, :count).by(1)
    end

    it "既存のタグが追加された場合、tagの数が増加していないこと" do
      quest_change_tag_params[:tag_name] = "sports"
      expect do
        patch quest_path(public_quest1), params: { quest: quest_change_tag_params }
      end.to change(Tag, :count).by(0)
    end

    it "クエストのタグを無くした場合、tagの数は変化していないこと" do
      quest_change_tag_params[:tag_name] = ""
      expect do
        patch quest_path(public_quest1), params: { quest: quest_change_tag_params }
      end.to change(Tag, :count).by(0)
    end
  end

  describe "DELETE #destroy" do
    let!(:non_public_quest1) { create(:non_public_quest, :tag_name_trip, user: user) }

    it "クエストが削除されても、tagの数は変化しないこと" do
      expect do
        delete quest_path(non_public_quest1)
      end.to change(Tag, :count).by(0)
    end
  end
end
