class CreateQuestTags < ActiveRecord::Migration[6.1]
  def change
    create_table :quest_tags do |t|
      t.references :quest, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
      t.timestamps
    end

    add_index :quest_tags, [:quest_id, :tag_id], unique: true
  end
end
