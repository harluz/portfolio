class AddQuestRefToRooms < ActiveRecord::Migration[6.1]
  def change
    add_reference :rooms, :quest, null: false, foreign_key: true
    change_column_null :rooms, :quest_id, false
  end
end
