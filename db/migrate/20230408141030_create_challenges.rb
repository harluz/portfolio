class CreateChallenges < ActiveRecord::Migration[6.1]
  def change
    create_table :challenges do |t|
      t.integer :user_id
      t.integer :quest_id
      t.boolean :close

      t.timestamps
    end
  end
end
