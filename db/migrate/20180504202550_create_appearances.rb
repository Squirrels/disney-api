class CreateAppearances < ActiveRecord::Migration[5.1]
  def change
    create_table :appearances do |t|
    	t.string  :name
			t.integer :appearance_type_id

      t.timestamps
    end
  end
end
