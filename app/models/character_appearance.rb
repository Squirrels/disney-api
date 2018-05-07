class CharacterAppearance < ApplicationRecord
	belongs_to :character
	belongs_to :appearance
end
