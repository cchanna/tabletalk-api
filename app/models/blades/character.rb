class Blades::Character < ApplicationRecord
  validates :name, presence: true
  validates :healing_unlocked, :harm_severe, :harm_moderate1, :harm_moderate2,
            :harm_lesser1, :harm_lesser2, :armor_normal, :armor_heavy,
            inclusion: { in: [true, false] }
  validates :name, :aka, length: { maximum: 50 }
  validates :playbook, length: { maximum: 20 }
  validates :stress, :healing_clock, :playbook_xp, :hunt, :study,
            :survey, :tinker, :finesse, :prowl, :skirmish, :wreck, :attune,
            :command, :consort, :sway, :insight_xp, :prowess_xp, :resolve_xp,
            :coin, :stash, :load,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }
  validates :playbook_xp, :healing_clock, numericality: {
    less_than_or_equal_to: 8
  }
  validates :prowess_xp, :insight_xp, :resolve_xp, :load, numericality: {
    less_than_or_equal_to: 6
  }
  validates :stress, numericality: {
    less_than_or_equal_to: 9
  }
  validates :hunt, :study, :survey, :tinker, :finesse, :prowl, :skirmish,
            :wreck, :attune, :command, :consort, :sway, :coin,
            numericality: { less_than_or_equal_to: 4 }
  validates :stash, numericality: { less_than_or_equal_to: 40 }

  has_many :blades_character_permissions, foreign_key: :character

  def update_pattern
    {
      id: :id,
      names: {
        name: :name,
        playbook: :playbook,
        alias: :aka
      },
      details: {
        look: :look,
        heritage: :heritage,
        background: :background,
        vice: :vice
      },
      stats: {
        xp: :playbook_xp,
        money: {
          coin: :coin,
          stash: :stash
        },
        insight: {
          xp: :insight_xp,
          hunt: :hunt,
          study: :study,
          survey: :survey,
          tinker: :tinker
        },
        prowess: {
          xp: :prowess_xp,
          finesse: :finesse,
          prowl: :prowl,
          skirmish: :skirmish,
          wreck: :wreck
        },
        resolve: {
          xp: :resolve_xp,
          attune: :attune,
          command: :comand,
          consort: :consort,
          sway: :sway
        }
      },
      health: {
        stress: :stress,
        healing: {
          unlocked: :healing_unlocked,
          clock: :healing_clock,
        },
        harm: {
          severe: :harm_severe,
          moderate1: :harm_moderate1,
          moderate2: :harm_moderate2,
          lesser1: :harm_lesser1,
          lesser2: :harm_lesser2
        },
        armor: {
          normal: :armor_normal,
          heavy: :armor_heavy
        }
      },
      equipment: {
        load: :load
      }
    }
  end

  def update_through pattern, with:
    data = with
    if pattern.respond_to? :each
      pattern.each do |key, value|
        if data.respond_to? :key?
          if data.key? key
            update_through value, with: data[key]
          end
        end
      end
    else
      method = pattern.to_s + '='
      if respond_to? method
        send method, data
      end
    end
  end

  def get_through pattern
    data = {}
    pattern.each do |key, value|
      if value.respond_to? :each
        data[key] = get_through value
      else
        if respond_to? value
          data[key] = send value
        end
      end
    end
    return data
  end

  def update_with data, as:
    id = as.respond_to?(:id) ? as.id : as
    permission = Blades::CharacterPermission.find_by player_id: id, character: self
    return nil unless permission && permission.edit
    update_through update_pattern, with: data
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
          data[character.id] = character.load_data as: player_id
        end
      end
    end
    return data
  end

  def load_data as:
    player_id = as.respond_to?(:id) ? as.id : as
    pms = Blades::CharacterPermission.where character: self
    permission = pms.find_by player_id: player_id
    return unless permission.view
    permissions = {}
    pms.each do |pm|
      permission = {
        view: pm.view,
        edit: pm.edit
      }
      permissions[pm.player_id] = permission
    end
    data = get_through update_pattern
    data[:permissions] = permissions
    data[:strangeFriends] = [
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
    ]
    data[:health][:trauma] = ['Cold', 'Haunted']
    data[:specialAbilities] = [
      {
        name: 'Foresight',
        description: 'Three times per score you can assist another rogue without paying stress. Tell us how you prepared them for the situation',
      }
    ]
    data[:equipment][:items] = [
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
    return data
  end

end
