class CreateRentals < ActiveRecord::Migration
  def change
    create_table :rentals do |t|
      t.string :description
      t.decimal :amount, :precision => 8, :scale => 2
      t.decimal :amount_per_day, :precision => 8, :scale => 2
      t.datetime :first_date
      t.datetime :last_date
      t.integer :project_id
      t.integer :user_id

      t.timestamps
    end
  end
end
