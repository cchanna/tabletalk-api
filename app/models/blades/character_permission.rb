class Blades::CharacterPermission < ApplicationRecord
  belongs_to :player
  belongs_to :character
end
