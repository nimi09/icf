class CreateWorkinghours < ActiveRecord::Migration
  def change
    create_table :workinghours do |t|
      t.datetime :date
      t.integer :hours
      t.integer :minutes
      t.string :remarks
      t.integer :project_id
      t.integer :user_id

      t.timestamps
    end
  end
end
