class ChangeColumnDetailsToUsers < ActiveRecord::Migration[6.0]
  def change
  	change_column :users, :role, :integer, null: false, default: 2
  end
end
