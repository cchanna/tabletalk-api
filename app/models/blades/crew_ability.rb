class Blades::CrewAbility < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }

  belongs_to :crew

  def self.abilities
    {
      "Everyone Steals" => {
        description: %q{
          Each PC may add +1 action rating to *Prowl*, *Finesse*, or *Tinker*
          (up to a max rating of 3).
        }.gsub(/\s+/, ' ').strip
      },
      "Ghost Echoes" => {
        description: %q{
          From weird experience or occult ritual, all crew members gain the
          ability to see and interact with the spirit world of the First City.
        }.gsub(/\s+/, ' ').strip
      },
      "No Traces" => {
        description: %q{
          When you keep an operation quiet or make it look like an accident, you
          get half the rep value of the target (round up) instead of zero. When
          you end *downtime* with zero heat, take *+1 rep*.
        }.gsub(/\s+/, ' ').strip
      },
      "Pack Rats" => {
        description: %q{
          Your lair is a jumble of stolen items. When you roll to *acquire an
          asset*, take *+1d*.
        }.gsub(/\s+/, ' ').strip
      },
      "Patron" => {
        description: %q{
          When you advance your *Tier*, it costs *half the coin* it normally
          would. _Who is your patron? Why do they help you?_
        }.gsub(/\s+/, ' ').strip
      },
      "Second Story" => {
        description: %q{
          When you execute a clandestine infiltration, you get *+1d* to the
          *engagement roll*.
        }.gsub(/\s+/, ' ').strip
      },
      "Slippery" => {
        description: %q{
          When you roll *entanglements*, roll twice and keep the one you want.
          When you *reduce heat* on the crew, take *+1d*.
        }.gsub(/\s+/, ' ').strip
      },
      "Synchronized" => {
        description: %q{
          When you perform a *group action*, you may count multiple 6s from
          different rolls as a critical success.
        }.gsub(/\s+/, ' ').strip
      }
    }
  end

  def self.playbook_abilities
    {
      "Shadows" => [
        "Everyone Steals", "Pack Rats", "Slippery", "Synchronized", "Second Story",
        "Patron", "Ghost Echoes"
      ]
    }
  end

  def self.compare a, b, playbook_name
    pb = playbook_abilities[playbook_name]
    return 0 if a == b
    if pb and pb.include? a.name
      return -1 unless pb.include? b.name
      a_index = pb.find_index a.name
      b_index = pb.find_index b.name
      return -1 if a_index < b_index
      return 1 if a_index > b_index
    else
      return 1 if pb.include? b.name
      return a.name <=> b.name
    end
    return 0
  end

  def to_json
    result = self.class.abilities[name]
    result = {} unless result
    result[:name] = name
    return result
  end
end
