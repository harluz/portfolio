class CreateGradeSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :grade_settings do |t|
      t.integer :tag,           null: false
      t.string :grade,          null: false
      t.integer :judgement_xp,  null: false

      t.timestamps
    end
  end
end
