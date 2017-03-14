module Blades
  def self.table_name_prefix
    'blades_'
  end

  def self.load as:
    data = {}
    player = as

    data[:chats] = Chat
      .order(created_at: :desc)
      .where(player: player.game.players)
      .limit(100)
      .left_outer_joins(:talk)
      .left_outer_joins(roll: :dice)
      .left_outer_joins(:log)
      .select('chats.*, talks.message as talk_message, rolls.bonus as roll_bonus, logs.message as log_message, array_agg(dice.result) as roll_dice')
      .group('chats.id, talks.message, rolls.bonus, logs.message')
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
        when chat.log_message
          result[:action] = 'log'
          result[:message] = chat.log_message
        end
        result
      }
      .reverse

    data[:library] = {
      crew: {
        abilities: {
          def: CrewAbility.abilities,
          playbook: CrewAbility.playbook_abilities
        }
      },
      character: {
        abilities: {
          def: CharacterAbility.abilities,
          playbook: CharacterAbility.playbook_abilities
        }
      }
    }


    result = Character.load as: as
    return result if result.failed?
    data[:characters] = result.value

    result = Crew.load as: as
    result result if result.failed?
    data[:crews] = result.value

    return Result.success data
  end
end
