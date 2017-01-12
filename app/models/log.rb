class Log < ApplicationRecord
  belongs_to :chat
  validates :message, presence: true

  def to_json
    return {
      id: chat.id,
      action: 'log',
      player: chat.player_id,
      message: self.message,
      timestamp: chat.created_at
    }
  end
end
