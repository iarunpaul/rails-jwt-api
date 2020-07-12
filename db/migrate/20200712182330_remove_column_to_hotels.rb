class RemoveColumnToHotels < ActiveRecord::Migration[6.0]
  def change
  	remove_column :hotels, :created_by
  	remove_column :hotels, :updated_by
  	add_column :hotels, :owner_id, :integer, null: false
  end
end
