class CreateAppearanceTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :appearance_types do |t|
    	t.string :name
    	
      t.timestamps
    end
  end
end
