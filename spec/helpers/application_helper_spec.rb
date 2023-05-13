require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "full_title(page_tile)" do
    it "page_titleが表示されること" do
      expect(helper.full_title("クエスト一覧")).to eq "クエスト一覧 | BranChannel"
    end

    it "page_titleが空である場合、BASE_TITLEが表示されること" do
      expect(helper.full_title(nil)).to eq "BranChannel"
    end

    it "page_titleがnilである場合、BASE_TITLEが表示されること" do
      expect(helper.full_title(nil)).to eq "BranChannel"
    end
  end
end
