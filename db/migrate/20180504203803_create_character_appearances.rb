class CreateCharacterAppearances < ActiveRecord::Migration[5.1]
  def change
    create_table :character_appearances do |t|
    	t.integer :character_id
    	t.integer :appearance_id

      t.timestamps
    end
  end
end
