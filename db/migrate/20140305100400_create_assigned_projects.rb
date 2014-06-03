class CreateAssignedProjects < ActiveRecord::Migration
  def change
    create_table :assigned_projects do |t|
      t.integer :user_id
      t.integer :project_id

      t.timestamps
    end
  end
end
