require 'rails_helper'

RSpec.describe "Tests", type: :system do
  describe "テスト疎通確認" do
    before do
      visit test_path
    end

    it "タイトルがMyappになっていること" do
      expect(page).not_to have_title "Myapp"
    end
  end
end
