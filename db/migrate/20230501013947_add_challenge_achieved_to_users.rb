class AddChallengeAchievedToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :challenge_achieved, :integer, null: false, default: 0
  end
end
