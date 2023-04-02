class CreateQuests < ActiveRecord::Migration[6.1]
  def change
    create_table :quests do |t|
      t.string :title,       null: false
      t.text :describe,      null: false
      t.integer :difficulty, null: false, default: 1
      t.integer :xp,         null: false
      t.boolean :public,     null: false, default: false
      t.integer :challenge_id

      t.timestamps
    end
  end
end
