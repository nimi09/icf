class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.string :description
      t.float :amount
      t.datetime :date
      t.integer :project_id
      t.integer :user_id

      t.timestamps
    end
  end
end
