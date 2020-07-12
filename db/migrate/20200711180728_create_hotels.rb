class CreateHotels < ActiveRecord::Migration[6.0]
  def change
    create_table :hotels do |t|
      t.string :name
      t.string :class
      t.text :description
      t.integer :creator_id

      t.timestamps
    end
  end
end
