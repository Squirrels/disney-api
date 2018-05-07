class Character < ApplicationRecord
	has_many :character_appearances
  has_many :appearances, through: :character_appearances
end
