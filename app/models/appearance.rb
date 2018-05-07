class Appearance < ApplicationRecord
	has_many :character_appearances
  has_many :characters, through: :character_appearances
  has_one  :appearance_type
end
