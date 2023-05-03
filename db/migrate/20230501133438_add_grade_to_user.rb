class AddGradeToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :grade, :string, null: false, default: "First Stepper"
  end
end
