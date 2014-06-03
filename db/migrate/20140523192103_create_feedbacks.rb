class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :subject
      t.string :content
      t.integer :votes, default: 0

      t.timestamps
    end
  end
end
