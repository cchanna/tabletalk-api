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

  def load_data as:
    player = as.respond_to?(:id) ? as : Player.find_by(id: as)
    unless view_permission.players.include? player
      return Result.failure "You do not have permission to view this crew", 403
    end
    data = to_json
    return Result.success data
  end

  def to_json
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
      claims: Blades::Claim.map(claims, playbook: playbook),
      abilities: abilities.sort{ |a,b|
          CrewAbility.compare a, b, playbook
      }.map { |ability| ability.to_json },
      contacts: contacts.map { |contact| contact.to_json },
      upgrades: upgrades.map { |upgrade| upgrade.to_json },
      cohorts: cohorts.map { |cohort| cohort.to_json },
      availableUpgrades: available_upgrades,
      edit: edit_permission.to_json,
      view: view_permission.to_json
    }
  end
end
