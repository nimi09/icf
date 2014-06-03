class AddPositionToAssignedProject < ActiveRecord::Migration
  def change
    add_column :assigned_projects, :position, :string
  end
end
