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
  belongs_to :crew, optional: true
  has_many :strange_friends, dependent: :destroy
  has_many :abilities, class_name: :CharacterAbility

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

  def self.do(args, key:, as:)
    action = args[:action].parameterize.underscore.to_sym
    case action
    when :create
    else
      id = args[:id]
      character = find_by id: id
      character.do action, with: args[:value], key: key, as: as
    end
  end

  def load_data as:
    player = as.respond_to?(:id) ? as : Player.find_by(id: as)
    unless view_permission.players.include? player
      return Result.failure "You do not have permission to view this character", 403
    end
    data = to_json
    return Result.success data
  end

  def broadcast data
    data[:id] = id
    view_permission.broadcast({
      key: @key,
      action: "do",
      what: :character,
      data: data
    })
  end

  def log message
    if @player
      Chat.log player: @player, message: message, permission: view_permission
    end
  end

  def edit_actions
    [
      :increment_coin, :decrement_coin, :transfer_to_coin, :transfer_to_stash,
      :increment_xp, :decrement_xp, :advance_action,
      :increment_stress, :decrement_stress, :add_trauma,
      :edit_harm, :use_armor,
      :unlock_healing, :increment_healing, :decrement_healing,
      :use_item, :clear_item, :clear_items, :set_load
    ]
  end

  def increment_coin
    return unless coin < 4
    update coin: coin + 1
    broadcast action: :increment_coin
    log "#{name} earned a coin (#{self.coin})"
  end

  def decrement_coin
    return unless coin > 0
    update coin: coin - 1
    broadcast action: :decrement_coin
    log "#{name} spent a coin (#{self.coin})"
  end

  def transfer_to_stash
    return unless stash < 40 and coin > 0
    update stash: stash + 1, coin: coin - 1
    broadcast action: :transfer_to_stash
    log "#{name} stashed a coin (#{self.stash})"
  end

  def transfer_to_coin
    return unless stash >= 2 and coin < 4
    update stash: stash - 2, coin: coin + 1
    broadcast action: :transfer_to_coin
    log "#{name} withdrew from their stash (#{self.stash})"
  end

  def increment_xp stat
    prop = stat.to_s.parameterize.underscore + '_xp'
    value = send prop
    if (stat == "playbook")
      return unless value < 8
    else
      return unless value < 6
    end
    update prop => value + 1
    broadcast action: :increment_xp, value: stat
    log "#{name} raised their #{stat.to_s.downcase} XP to #{value + 1}"
  end

  def decrement_xp stat
    prop = stat.to_s.parameterize.underscore + '_xp'
    value = send prop
    return unless value > 0
    update prop => value - 1
    broadcast action: :decrement_xo, value: stat
    log "#{name} lowered their #{stat.to_s.downcase} XP to #{value - 1}"
  end

  def advance_action action
    legal_actions = {
      hunt: :insight, study: :insight, survey: :insight, tinker: :insight,
      finesse: :prowess, prowl: :prowess, skirmish: :prowess, wreck: :prowess,
      attune: :resolve, command: :resolve, consort: :resolve, sway: :resolve
    }
    prop = action.to_s.parameterize.underscore.to_sym
    puts prop.inspect
    return unless legal_actions.include? prop
    value = send prop
    xp_prop = (legal_actions[prop].to_s + '_xp').to_sym
    xp = send xp_prop
    return unless value < 4
    return unless value < 3 or mastery
    return unless xp >= 6
    update prop => value + 1, xp_prop => 0
    broadcast action: :advance_action, value: action
    log "#{name} raised their #{prop.to_s} to #{value + 1}"
  end

  def increment_stress
    return unless stress < 9
    update stress: stress + 1
    broadcast action: :increment_stress
    log "#{name} raised their stress to #{stress}"
  end

  def decrement_stress
    return unless stress > 0
    update stress: stress - 1
    broadcast action: :decrement_stress
    log "#{name} lowered their stress to #{stress}"
  end

  def add_trauma value
    return unless stress == 9
    update stress: 0, trauma: trauma.push(value.to_s.downcase)
    broadcast action: :add_trauma, value: value.to_s.downcase
    log "#{name} gained the trauma \"#{value.to_s.upcase}\""
  end

  def edit_harm value
    harm = value[:harm].to_s.downcase
    text = value[:text].to_s.downcase
    prop = ("harm_" + harm).parameterize.underscore.to_sym
    current_value = send prop
    level = "severe"
    if harm.include? "moderate"
      level = "moderate"
    elsif harm.include? "lesser"
      level = "lesser"
    end
    if current_value.blank? and !text.blank?
      update healing_unlocked: false
      log "#{name} suffered the #{level} harm \"#{text.upcase}\""
    elsif !current_value.blank? and text.blank?
      log "#{name} healed their #{level} harm \"#{current_value.upcase}\""
    elsif !current_value.blank? and !text.blank?
      log "#{name}'s #{level} harm \"#{current_value.upcase} was renamed to \"#{text.upcase}\""
    end
    update prop => text
    broadcast action: :edit_harm, value: {harm: harm, text: text}
  end

  def use_armor value
    armor_name = value[:name].downcase
    used = value[:used]
    action = used ? "used" : "refreshed"
    if armor_name == "armor"
      if armor_normal != used
        update armor_normal: used
        if !used
          update armor_heavy: false
        end
        log "#{name} #{action} their armor"
        broadcast action: :use_armor, value: {name: "armor", used: used}
      end
    elsif armor_name == "heavy"
      if armor_heavy != used
        update armor_heavy: used
        log "#{name} #{action} their heavy armor"
        broadcast action: :use_armor, value: {name: "heavy", used: used}
      end
    elsif armor_name == "special"
      if armor_special != used
        update armor_special: used
        log "#{name} #{action} their special armor"
        broadcast action: :use_armor, value: {name: "special", used: used}
      end
    end
  end

  def unlock_healing value
    return unless healing_unlocked != value
    update healing_unlocked: value
    action = ""
    if value
      action = "unlocked"
    else
      action = "locked"
    end
    log "#{name} #{action} their healing clock"
    broadcast action: :unlock_healing, value: value
  end

  def increment_healing
    return unless healing_unlocked
    if healing_clock < 4
      update healing_clock: healing_clock + 1
      broadcast action: :increment_healing
      log "#{name} advanced their healing clock to #{healing_clock}"
    else
      update healing_clock: vigor, harm_severe: "", harm_moderate1: "",
             harm_moderate2: "", harm_lesser1: "", harm_lesser2: "",
             healing_unlocked: false
      broadcast action: :increment_healing
      log "#{name} healed their wounds"
    end
  end

  def decrement_healing
    return unless healing_unlocked and healing_clock > vigor
    update healing_clock: healing_clock - 1
    broadcast action: :decrement_healing
    log "#{name} reduced their healing clock to #{healing_clock}"
  end

  def use_item value
    return if items.include? value
    items.push value
    if value == "+Heavy" and !items.include? "Armor"
      items.push "Armor"
    end
    save!
    broadcast action: :use_item, value: value
    log "#{name} used the item \"#{value}\""
  end

  def clear_item value
    return unless items.include? value
    items.delete value
    if value == "Armor"
      items.delete "+Heavy"
      update armor_normal: false, armor_heavy: false
    elsif value == "+Heavy"
      update armor_heavy: false
    end
    save!
    broadcast action: :clear_item, value: value
    log "#{name} returned the item \"#{value}\""
  end

  def clear_items
    update items: [], load: 0,
           armor_normal: false, armor_heavy: false, armor_special: false
    broadcast action: :clear_items
    log "#{name} reset their loadout"
  end

  def set_load value
    return if value == load
    update load: value
    broadcast action: :set_load, value: value
    if load == 6 + load_bonus
      log "#{name} is using a heavy load"
    elsif load == 5 + load_bonus
      log "#{name} is using a normal load"
    elsif load == 3 + load_bonus
      log "#{name} is using a light load"
    else
      log "#{name} is using a load of #{load}"
    end
  end

  def do(action, with:nil, key:, as:)
    @player = as.respond_to?(:id) ? as : Player.find_by(id: as)
    @key = key
    if edit_actions.include? action
      return unless edit_permission.players.include? @player
      if with == nil
        self.send action
      else
        self.send action, with
      end
    end
  end

  def to_json
    return {
      id: id,
      name: name,
      playbook: playbook,
      alias: aka,
      look: look,
      heritage: heritage,
      background: background,
      vice: vice,
      playbookXP: playbook_xp,
      coin: coin,
      stash: stash,
      insightXP: insight_xp,
      hunt: hunt,
      study: study,
      survey: survey,
      tinker: tinker,
      prowessXP: prowess_xp,
      finesse: finesse,
      prowl: prowl,
      skirmish: skirmish,
      wreck: wreck,
      resolveXP: resolve_xp,
      attune: attune,
      command: command,
      consort: consort,
      sway: sway,
      stress: stress,
      trauma: trauma,
      healingUnlocked: healing_unlocked,
      healingClock: healing_clock,
      harmSevere: harm_severe,
      harmModerate1: harm_moderate1,
      harmModerate2: harm_moderate2,
      harmLesser1: harm_lesser1,
      harmLesser2: harm_lesser2,
      armor: armor_normal,
      heavyArmor: armor_heavy,
      specialArmor: armor_special,
      load: load,
      items: items,
      editPermission: edit_permission.to_json,
      viewPermission: view_permission.to_json,
      specialAbilities: abilities.sort.map { |a| a.to_json },
      strangeFriends: strange_friends.map {|sf| sf.to_json},
      crewId: crew ? crew.id : nil
    }
  end

private

  def vigor
    result = 0
    special_abilities.each do |a|
      if Blades::Ability.get(a)[:vigor]
        result += 1
      end
    end
    return result
  end

  def load_bonus
    result = 0
    special_abilities.each do |a|
      ability = Blades::Ability.get(a)
      if ability[:load]
        result += ability[:load]
      end
    end
    return result
  end

  def mastery
    upgrades.where(name: "Mastery").count > 0
  end

end
