module Adventure
  def self.table_name_prefix
    'adventure_'
  end

  def self.load as:
    data = {}
    player = as
    chats = Chat
      .order(created_at: :desc)
      .where(player: player.game.players)
      .limit(100)
      .left_outer_joins(:talk)
      .left_outer_joins(roll: :dice)
      .select('chats.*, talks.message as talk_message, rolls.bonus as roll_bonus, array_agg(dice.result) as roll_dice')
      .group('chats.id, talks.message, rolls.bonus')
      .map { |chat|
        result = {
          id: chat.id,
          player: chat.player_id,
          timestamp: chat.created_at.to_f * 1000
        }
        case
        when chat.talk_message
          result[:action] = 'talk'
          result[:message] = chat.talk_message
        when chat.roll_bonus
          result[:action] = 'roll'
          result[:bonus] = chat.roll_bonus
          result[:result] = chat.roll_dice
        end
        result
      }.reverse

    data = {
      chats: chats
    }

    return Result.success data
  end
end
