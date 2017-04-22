class QueenKiller::Kiss < ApplicationRecord
  belongs_to :suitor, class_name: :Character
  belongs_to :love, class_name: :Character
end
