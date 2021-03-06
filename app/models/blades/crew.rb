class Blades::Crew < ApplicationRecord
  validates :name, presence: true
  validates :name, :reputation, :hunting_grounds, :playbook, length: {
    maximum: 50
  }
  validates :rep, :tier, :heat, :wanted_level, :coin, :xp,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }
  validates :strong, inclusion: { in: [true, false] }

  belongs_to :edit_permission, class_name: :Permission
  belongs_to :view_permission, class_name: :Permission
  belongs_to :game


  has_many :characters
  has_many :claims, dependent: :destroy
  has_many :abilities, class_name: :CrewAbility, dependent: :destroy
  has_many :contacts, dependent: :destroy
  has_many :upgrades, class_name: :CrewUpgrade, dependent: :destroy
  has_many :cohorts, dependent: :destroy

  def self.load as:
    player = as.respond_to?(:id) ? as : Player.find_by(id: as)
    data = {}
    crews = where(game: player.game)
    crews.each do |crew|
      if crew.view_permission.players.include? player
        result = crew.load_data as: player
        data[crew.id] = result.value if result.succeeded?
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
      crew = find_by id: id
      crew.do action, with: args[:value], key: key, as: as
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

  def load_data as:
    player = as.respond_to?(:id) ? as : Player.find_by(id: as)
    unless view_permission.players.include? player
      return Result.failure "You do not have permission to view this crew", 403
    end
    data = to_json
    return Result.success data
  end

  def to_json
    upgradesMap = Blades::CrewUpgrade.map(upgrades, playbook)
    return {
      id: id,
      name: name,
      playbook: playbook,
      reputation: reputation,
      rep: rep,
      strong: strong,
      tier: tier,
      heat: heat,
      wantedLevel: wanted_level,
      coin: coin,
      xp: xp,
      huntingGrounds: hunting_grounds,
      huntingGroundsDescription: hunting_grounds_description,
      lair: lair,
      claims: Blades::Claim.map(claims, playbook),
      abilities: abilities.sort{ |a,b|
          Blades::CrewAbility.compare a, b, playbook
      }.map { |ability| ability.to_json },
      contacts: contacts.map { |contact| contact.to_json },
      lairUpgrades: upgradesMap[:lair],
      qualityUpgrades: upgradesMap[:quality],
      trainingUpgrades: upgradesMap[:training],
      crewUpgrades: upgradesMap[:crew],
      cohorts: cohorts.map { |cohort| cohort.to_json },
      availableUpgrades: available_upgrades,
      edit: edit_permission.to_json,
      view: view_permission.to_json
    }
  end

  def broadcast data
    data[:id] = id
    view_permission.broadcast({
      key: @key,
      action: "do",
      what: :crew,
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
      :increment_xp, :decrement_xp, :increment_heat, :decrement_heat,
      :serve_time, :increment_coin, :decrement_coin,
      :increment_rep, :decrement_rep, :toggle_claim,
      :add_upgrade, :add_ability
    ]
  end

  def increment_xp
    if xp < 7
      update xp: xp + 1
      broadcast action: :increment_xp
      log "#{name} gained an XP (#{xp})"
    else
      update xp: 0, available_upgrades: available_upgrades + 2
      characters.each do |c|
        c.update stash: c.stash + 1 + (2 * tier)
      end
      broadcast action: :increment_xp
      log "#{name} leveled up!"
    end
  end

  def decrement_xp
    return unless xp > 0
    update xp: xp - 1
    broadcast action: :decrement_xp
    log "#{name} lost an XP (#{xp})"
  end

  def increment_heat
    if heat < 8
      update heat: heat + 1
      broadcast action: :increment_heat
      log "#{name} drew heat (#{heat})"
    elsif wanted_level < 4
      update heat: 0, wanted_level: wanted_level + 1
      broadcast action: :increment_heat
      log "#{name} is wanted (#{wanted_level})"
    end
  end

  def decrement_heat
    return unless heat > 0
    update heat: heat - 1
    broadcast action: :decrement_heat
    log "#{name} reduced heat (#{heat})"
  end

  def serve_time
    return unless wanted_level > 0
    update wanted_level: wanted_level - 1
    broadcast action: :serve_time
    log "#{name} got someone arrested, wanted level reduced to #{wanted_level}"
  end

  def increment_coin
    return unless coin < 16
    return unless vaults > 1 or coin < 8
    return unless vaults > 0 or coin < 4
    update coin: coin + 1
    broadcast action: :increment_coin
    log "#{name} earned a coin (#{coin})"
  end

  def decrement_coin
    return unless coin > 0
    update coin: coin - 1
    broadcast action: :decrement_coin
    log "#{name} spent a coin (#{coin})"
  end

  def increment_rep
    target = 12 - [turf, 6].min
    if (!strong) and rep >= target - 1
      update rep: 0, strong: true
      broadcast action: :increment_rep
      log "#{name} gained a strong hold"
    elsif rep < target
      update rep: rep + 1
      broadcast action: :increment_rep
      log "#{name} gained rep (#{rep})"
    end
  end

  def decrement_rep
    return unless rep > 0
    update rep: rep - 1
    broadcast action: :decrement_rep
    log "#{name} spent rep (#{rep})"
  end

  def toggle_claim value
    return unless value.has_key? :r and value.has_key? :c
    r = value[:r]
    c = value[:c]
    claim = claims.find_by row: r, column: c
    if claim
      claim.destroy
      broadcast action: :toggle_claim, value: value
      log "#{name} lost the claim \"#{claim.name}\""
    else
      claim = claims.create row: r, column: c
      broadcast action: :toggle_claim, value: value
      log "#{name} gained the claim \"#{claim.name}\""
    end
  end

  def add_upgrade value
    count = upgrades.where(name: value).count
    max = Blades::CrewUpgrade.max(value)
    cost = Blades::CrewUpgrade.cost(value)
    if available_upgrades >= cost and count < max
      upgrades.create name: value
      update available_upgrades: available_upgrades - cost
      broadcast action: :add_upgrade, value: value
      log "#{name} gained the upgrade \"#{value}\""
    end
  end

  def add_ability value
    ability_name = value[:name]
    veteran = value[:veteran]
    return if abilities.find_by name: ability_name
    abilities.create name: ability_name, veteran: veteran
    update available_upgrades: available_upgrades - 2
    broadcast action: :add_ability, value: value
    log "#{name} gained the ability \"#{ability_name}\""
  end

private

  def vaults
    return upgrades.where(name: "Vault").count
  end

  def turf
    result = 0
    claims.each do |c|
      result += 1 if c.name == "Turf"
    end
    return result
  end
end
