class Blades::StrangeFriend < ApplicationRecord
  validates :name, :title, presence: true, length: { maximum: 50 }

  belongs_to :character

  def to_json
    return {
      name: name,
      title: title,
      description: description,
      isFriend: is_friend
    }
  end

end
