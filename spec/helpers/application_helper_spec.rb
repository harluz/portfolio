require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  let(:user) { create(:user) }
  let(:other_user) { create(:correct_user) }
  let!(:quest) { create(:quest, user: user)}
  let!(:public_quest) { create(:public_quest, user: user)}
  let!(:non_public_quest) { create(:other_quest, user: user)}
  let!(:other_quest) { create(:quest, user: other_user)}
  let!(:challenge) { create(:challenge, user: user, quest: quest)}
  let!(:other_challenge) { create(:challenge, user: other_user, quest: quest)}

  before { sign_in user }

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

  describe '#is_not_own_challenge?' do
    it '挑戦中のクエストである場合は、falseとなること' do
      expect(helper.is_not_own_challenge?(quest)).to eq(false)
    end

    it '挑戦中でないクエストの場合は、trueとなること' do
      expect(helper.is_not_own_challenge?(other_challenge)).to eq(true)
    end
  end

  describe '#current_user_owned?' do
    it '自分が作成したクエストである場合は、trueとなること' do
      expect(helper.current_user_owned?(quest)).to eq(true)
    end

    it '自分の挑戦から呼び出しても自分が作成したクエストはtrueとなること' do
      expect(helper.current_user_owned?(challenge.quest)).to eq(true)
    end

    it '他ユーザーの挑戦から呼び出されても自分が作成したクエストはtrueとなること' do
      expect(helper.current_user_owned?(other_challenge.quest)).to eq(true)
    end

    it '自分が作成したクエストでない場合は、falseとなること' do
      expect(helper.current_user_owned?(other_quest)).to eq(false)
    end
  end

  describe '#public_quest?' do
    it '公開クエストはtrueとなること' do
      expect(helper.public_quest?(public_quest)).to eq(true)
    end

    it '非公開クエストはfalseとなること' do
      expect(helper.public_quest?(non_public_quest)).to eq(false)
    end
  end
end
