class Blades::Character < ApplicationRecord
  validates :name, :stress, :healing_clock, :playbook_xp, :hunt, :study,
            :survey, :tinker, :finesse, :prowl, :skirmish, :wreck, :attune,
            :command, :consort, :sway, :insight_xp, :prowess_xp, :resolve_xp,
            :coin, :stash, :load,
            presence: true
  validates :healing_unlocked, :harm_severe, :harm_moderate1, :harm_moderate2,
            :harm_lesser1, :harm_lesser2,
            inclusion: { in: [true, false] }
  validates :name, :aka, length: { maximum: 50 }
  validates :playbook, length: { maximum: 20 }

  has_many :blades_character_permissions, foreign_key: :character

  def update_with data, as:
    id = as.responds_to? :id ? as.id : as
    permission = Blades::CharacterPermission.find_by player_id: id, character: self
    return nil unless permission && permission.edit
    if data.key? :stats
      stats = data[:stats]
      if stats.key? :money
        money = stats[:money]
        self.coin = money[:coin] if money.key? :coin
        self.stash = money[:stash] if money.key? :stash
      end
    end
    return save
  end

  def self.update_with data, as:
    return nil unless data.key? :id
    character = find_by id: data[:id]
    return nil unless character
    return character.update_with data, as: as
  end

  def self.load player_id
    data = {}
    permissions = Blades::CharacterPermission.where player_id: player_id
    if permissions
      permissions.each do |permission|
        if permission.view
          character = permission.character
          data[character.id] = character.load_data
        end
      end
    end
    return data
  end

  def load_data
    data = {
      id: id,
      names: {
        name: name,
        playbook: playbook,
        alias: aka
      },
      details: {
        look: look,
        heritage: heritage,
        background: background,
        vice: vice,
      },
      strangeFriends: [
        {
          name: 'Neba Blood (Miss Blood)',
          position: 'Jack of Hearts',
          description: 'A former friend (former lover). Etoli.',
          friend: false
        },
        {
          name: 'Zopheea',
          position: 'cat-burglar',
          description: 'Narri/Whisper. Notorious. Hiding out in the Tin Quarter.',
          friend: true
        }
      ],
      health: {
        stress: stress,
        trauma: ['Cold', 'Haunted'],
        healing: {
          unlocked: healing_unlocked,
          clock: healing_clock
        },
        harm: {
          severe: harm_severe,
          moderate1: harm_moderate1,
          moderate2: harm_moderate2,
          lesser1: harm_lesser1,
          lesser2: harm_lesser2,
        },
        armor: {
          normal: false,
          heavy: false,
          special: [
            name: 'Mastermind',
            used: true
          ]
        }
      },
      specialAbilities: [
        {
          name: 'Foresight',
          description: 'Three times per score you can assist another rogue without paying stress. Tell us how you prepared them for the situation',
        }
      ],
      stats: {
        playbookXP: playbook_xp,
        hunt: hunt,
        study: study,
        survey: survey,
        tinker: tinker,
        finesse: finesse,
        prowl: prowl,
        skirmish: skirmish,
        wreck: wreck,
        attune: attune,
        command: command,
        consort: consort,
        sway: sway,
        insightXP: insight_xp,
        prowessXP: prowess_xp,
        resolveXP: resolve_xp,
        money: {
          coin: coin,
          stash: stash,
        }
      },
      equipment: {
        load: load,
        items: [
          {
            name: 'A blade or two',
            load: 1,
            used: false
          },
          {
            name: 'Throwing Knives',
            load: 1,
            used: true
          },
          {
            name: 'A Large Weapon',
            load: 2,
            used: false
          },
          {
            name: 'Fine cover identity',
            load: 0,
            used: true
          }
        ]
      }
    }
    return data
  end

end
