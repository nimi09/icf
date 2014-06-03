class CreateRevenues < ActiveRecord::Migration
  def change
    create_table :revenues do |t|
      t.string :description
      t.decimal :amount, :precision => 8, :scale => 2
      t.datetime :date
      t.integer :project_id
      t.integer :user_id

      t.timestamps
    end
  end
end
