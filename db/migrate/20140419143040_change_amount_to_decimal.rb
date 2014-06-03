class ChangeAmountToDecimal < ActiveRecord::Migration
  def up
  	change_column :expenses, :amount, :decimal, :precision => 8, :scale => 2
  end
end
