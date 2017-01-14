class Blades::Character < ApplicationRecord
  validates :name, presence: true
  validates :healing_unlocked, :armor_normal, :armor_heavy,
            inclusion: { in: [true, false] }
  validates :name, :aka, length: { maximum: 50 }
  validates :playbook, length: { maximum: 20 }
  validates :harm_severe, :harm_moderate1, :harm_moderate2, :harm_lesser1,
            :harm_lesser2, length: { maximum: 30 }
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

  belongs_to :edit_permission, class_name: :Permission
  belongs_to :view_permission, class_name: :Permission
  belongs_to :game
  has_many :armors, class_name: :Armor, foreign_key: :character_id

  def special_armors= data
  end

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
          command: :command,
          consort: :consort,
          sway: :sway
        }
      },
      health: {
        stress: :stress,
        trauma: :trauma!,
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
          heavy: :armor_heavy,
          special: :armors?
        }
      },
      equipment: {
        load: :load,
        items: :items?
      },
      permissions: {
        edit: :edit_permission!,
        view: :view_permission!,
      },
      specialAbilities: :special_abilities!
    }
  end

  def trauma!
    return [] unless trauma
    return trauma.split(" ")
  end

  def special_abilities!
    return special_abilities
  end

  def edit_permission!
    edit_permission.players.map { |player| player.id }
  end

  def view_permission!
    view_permission.players.map { |player| player.id }
  end

  def update_with data, as:
    player = as.respond_to?(:id) ? as : Player.find_by(id: as)
    unless edit_permission.players.include? player
      return Result.failure "You do not have the required permissions to edit that character", 403
    end
    result = update_through update_pattern, with: data, as: as
    return result if result.failed?
    unless save
      return Result.failure errors.messages, 400
    end
    logs = []
    actions = []
    if result.value.respond_to? :flatten
      actions = result.value.flatten
    end
    actions.each do |action|
      chatResult = Chat.log player: player, message: "{player} #{action}", permission: view_permission
      if chatResult.failed?
        logger.error 'CHAT FAILED'
        logger.error chatResult.print_errors
      else
        logs.push chatResult.value
      end
    end
    return Result.success Chat.to_json(logs)
  end

  def self.update_with data, as:
    unless data.key? :id
      return Result.failure "Character does not have id", 400
    end
    character = find_by id: data[:id]
    unless character
      return Result.failure "Could not find character", 404
    end
    return character.update_with data, as: as
  end

  def self.load as:
    player = as.respond_to?(:id) ? as : Player.find_by(id: as)
    data = {}
    characters = where(game: player.game)
    characters.each do |character|
      if character.view_permission.players.include? player
        result = character.load_data as: player
        data[character.id] = result.value if result.succeeded?
      end
    end
    return Result.success data
  end

  def load_data as:
    player = as.respond_to?(:id) ? as : Player.find_by(id: as)
    unless view_permission.players.include? player
      return Result.failure "You do not have permission to view this character", 403
    end
    data = get_through update_pattern
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
    return Result.success data
  end

private


  def add key, value
    if key == :trauma!
      self.trauma = trauma!.push(value.to_s.downcase).join(" ")
      return Result.success "added the trauma #{value.to_s.upcase} to #{name}"
    elsif key == :edit_permission! || name == :view_permission!
      field = name.to_s[0...-1]
      return self.send(field).add value
    end
  end

  def remove key, value
    if key == :trauma!
      trauma = trauma!
      if trauma.delete(value.to_s.downcase)
        self.trauma = trauma.join(" ")
        return Result.success "removed the trauma #{value.to_s.upcase} from #{name}"
      else
        return Result.failure "Trauma #{value.to_s.upcase} does not exist on character id #{id}", 404
      end
    elsif key == :edit_permission! || key == :view_permission!
      field = key.to_s[0...-1]
      return self.send(field).remove value
    end
  end

  def update_through pattern, with:, as:
    data = with
    actions = []
    if pattern == :id
      return Result.success []
    elsif pattern.respond_to? :each
      pattern.each do |key, value|
        if data.respond_to? :key?
          if data.key? key
            result = update_through value, with: data[key], as: as
            return result if result.failed?
            actions.push *(result.value)
          end
        end
      end
    else
      if pattern.to_s[-1] == '!'
        if data.respond_to? :each
          data.each do |key, value|
            result = nil
            if key == :add
              result = add pattern, value
            elsif key == :remove
              result = remove pattern, value
            end
            return result if result.failed?
            actions.push result.value if result.value
          end
        end
      elsif pattern.to_s[-1] == '?'
        method = pattern.to_s[0...-1]
        if respond_to? method
          array = send method
          if data.respond_to? :each and array.respond_to? :find_by
            data.each do |key, value|
              object = array.find_by(id: key.to_s)
              if object.respond_to? :update_with
                result = object.update_with value, as: as
                return result if result.failed?
                actions.push result.value
                puts result.inspect
              end
            end
          end
        end
      else
        method = pattern.to_s + '='
        from = ""
        if respond_to? pattern
          from = " from #{send(pattern).inspect.to_s}"
        end
        if respond_to? method
          send method, data
          actions.push "set #{name}'s #{pattern.to_s.gsub("_"," ").downcase}#{from} to #{data.inspect.to_s}"
        end
      end
    end
    return Result.success actions
  end

  def get_through pattern
    data = {}
    pattern.each do |key, value|
      if value.respond_to? :each
        data[key] = get_through value
      else
        method = value.to_s
        if method[-1] == '?'
          data[key] = {}
          method = method[0...-1]
          if respond_to? method
            array = send method
            if array.respond_to? :each
              array.each do |object|
                if object.respond_to? :id and object.respond_to? :to_json
                  data[key][object.id] = object.to_json
                end
              end
            end
          end
        elsif respond_to? method
          data[key] = send method
        end
      end
    end
    return data
  end

end
