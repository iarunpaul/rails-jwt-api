class AddColumnToHotels < ActiveRecord::Migration[6.0]
  def change
  	add_column :hotels, :updated_by, :integer
  	rename_column :hotels, :creator_id, :created_by
  end
end
