class Blades::Contact < ApplicationRecord
  validates :name, :title, presence: true, length: { maximum: 50 }
  validates :favorite, inclusion: { in: [true, false] }

  belongs_to :crew

  def to_json
    return {
      name: name,
      title: title,
      description: description,
      favorite: favorite
    }
  end
end
