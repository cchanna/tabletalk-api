class Blades::CrewAbility < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }

  belongs_to :crew
  has_one :veteran_ability, class_name: :VeteranCrewAbility, foreign_key: "ability_id"

  def self.abilities
    {
      "Accord" => {
        description: %q{
          Sometimes friends are as good as territory. You may count up to three
          *+3 faction statuses* you hold as if they are *turf*.
        }.gsub(/\s+/, ' ').strip,
        friendsAsTurf: true
      },
      "All Hands" => {
        description: %q{
          During *downtime*, one of your cohorts may perform a downtime activity
          for the crew to *acquire an asset*, *reduce heat*, or work on a
            *long-term project*.
        }.gsub(/\s+/, ' ').strip
      },
      "Anointed" => {
        description: %q{
          You get *+1d* to *resistance* rolls against supernatural threats. You
          get *+1d* to *healing* rolls when you have supernatural harm.
        }.gsub(/\s+/, ' ').strip
      },
      "Blood Brothers" => {
        description: %q{
          When you fight alongside your cohorts in combat, they get *+1d* for
          *teamwork* rolls (setup and group actions). All of your cohorts get
          the *Thugs* type for free (if they're already Thugs, add another
          Type).
        }.gsub(/\s+/, ' ').strip
      },
      "Bound in Darkness" => {
        description: %q{
          You may use *teamwork* with any cult member, regardless of the
          distance separating you. By taking 1 stress, your whispered message is
          heard by every cultist.
        }.gsub(/\s+/, ' ').strip
      },
      "Chosen" => {
        description: %q{
          Each PC may add +1 action rating to *Attune*, *Study*, or *Sway* (up
          to a max rating of 3).
        }.gsub(/\s+/, ' ').strip,
        bonus: ['Attune', 'Study', 'Sway']
      },
      "Conviction" => {
        description: %q{
          Each PC gains an additional *Vice*: Worship. When you indulge this
          vice and bring a pleasing sacrifice, you don't overindulge if you
          clear excess stress. In addition, your deity will *assist* any one
          action roll you make—from now until you indulge this vice again.
        }.gsub(/\s+/, ' ').strip
      },
      "Crow's Veil" => {
        description: %q{
          Due to hard-won experience or occult ritual, your activities are
          hidden from the notice of the death-seeker crows. You don't take extra
          heat when killing is involved on a score.
        }.gsub(/\s+/, ' ').strip
      },
      "Dangerous" => {
        description: %q{
          Each PC may add +1 action rating to *Hunt*, *Skirmish*, or *Wreck*
          (up to a max rating of 3).
        }.gsub(/\s+/, ' ').strip,
        bonus: ['Hunt', 'Skirmish', 'Wreck']
      },
      "Deadly" => {
        description: %q{
          Each PC may add +1 action rating to *Hunt*, *Prowl*, or *Skirmish*
          (up to a max rating of 3).
        }.gsub(/\s+/, ' ').strip,
        bonus: ['Hunt', 'Prowl', 'Skirmish']
      },
      "Door Kickers" => {
        description: %q{
          When you execute an assault plan, take *+1d* to the *engagement* roll.
        }.gsub(/\s+/, ' ').strip
      },
      "Emberdeath" => {
        description: %q{
          Due to hard-won experience or occult ritual, you know the arcane
          method to destroy a living victim's spirit at the moment you kill
          them. Take 3 stress to channel electroplasmic energy from the ghost
          field to disintegrate the spirit and dead body in a shower of sparking
          embers.
        }.gsub(/\s+/, ' ').strip
      },
      "Everyone Steals" => {
        description: %q{
          Each PC may add +1 action rating to *Prowl*, *Finesse*, or *Tinker*
          (up to a max rating of 3).
        }.gsub(/\s+/, ' ').strip,
        bonus: ['Prowl', 'Finesse', 'Tinker']
      },
      "Fiends" => {
        description: %q{
          Fear is as good as respect. You may count each *wanted level* as if it
          was *turf*.
        }.gsub(/\s+/, ' ').strip,
        wantedAsTurf: true
      },
      "Forged in the Fire" => {
        description: %q{
          Each PC has been toughened by cruel experience. You get *+1d* to
          *resistance* rolls.
        }.gsub(/\s+/, ' ').strip
      },
      "Ghost Echoes" => {
        description: %q{
          From weird experience or occult ritual, all crew members gain the
          ability to see and interact with the spirit world of the First City.
        }.gsub(/\s+/, ' ').strip
      },
      "Ghost Market" => {
        description: %q{
          Through arcane ritual or hard-won experience, you have discovered how
          to prepare your product for sale to ghosts and/or demons. _They do not
          pay in coin. What do they pay with?_
        }.gsub(/\s+/, ' ').strip
      },
      "Ghost Passage" => {
        description: %q{
          From harsh experience or occult ritual, all crew members become immune
          to possession by spirits, but may choose to "carry" a second ghost as
          a passanger within their body.
        }.gsub(/\s+/, ' ').strip
      },
      "Glory Incarnate" => {
        description: %q{
          Your deity sometimes manifests in the physical world. This can be a
          great boon, but the priorities and values of a god are not those of
          mortals. You have been warned.
        }.gsub(/\s+/, ' ').strip
      },
      "The Good Stuff" => {
        description: %q{
          Your merchandise is exquisite. The product *quality* is equal to your
          *Tier+2*. When you deal with a crew or faction, the GM will tell you
          who among them is hooked on your product (one, a few, many, or all).
        }.gsub(/\s+/, ' ').strip
      },
      "High Society" => {
        description: %q{
          It's all about who you know. Take *-1 heat* during downtime and *+1d*
          to *gather info* about the city's elite.
        }.gsub(/\s+/, ' ').strip
      },
      "Hooked" => {
        description: %q{
          Your gang members use your product. Add the *savage*, *unreliable*, or
          *wild* flaw to your gangs to give them *+1 quality*.
        }.gsub(/\s+/, ' ').strip
      },
      "Just Passing Through" => {
        description: %q{
          During *downtime*, take *-1 heat*. When your head it 4 or less, you
          get *+1d* to deceive people when you pass yourselves off as ordinary
          citizens.
        }.gsub(/\s+/, ' ').strip
      },
      "Leverage" => {
        description: %q{
          Your crew supplies contraband for other factions. Your success is good
          for them. Whenever you gain rep, gain *+1 rep*.
        }.gsub(/\s+/, ' ').strip
      },
      "Like Part of the Family" => {
        description: %q{
          Create one of your vehicles as a *cohort* (use the vehicle edges and
          flaws, below). Its *quality* is equal to your Tier +1. If the vehicle
          is upgraded, it also gets *armor*.
        }.gsub(/\s+/, ' ').strip,
        vehicle: true
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
      "Predators" => {
        description: %q{
          When you use stealth or subterfuge to commit murder, take *+1d* to the
          *engagement* roll.
        }
      },
      "Reavers" => {
        description: %q{
          When you go into conflict aboard a vehicle, you gain *+1 effect* for
          vehicle damage and speed. Your vehicle gains *armor*.
        }.gsub(/\s+/, ' ').strip
      },
      "Renegades" => {
        description: %q{
          Each PC may add +1 action rating to *Finesse*, *Prowl*, or *Skirmish*
          (up to a max rating of 3).
        }.gsub(/\s+/, ' ').strip,
        bonus: ['Finesse', 'Prowl', 'Skirmish']
      },
      "Sealed in Blood" => {
        description: %q{
          Each human sacrifice yields -3 stress cost for any ritual you perform.
        }.gsub(/\s+/, ' ').strip
      },
      "Second Story" => {
        description: %q{
          When you execute a clandestine infiltration, you get *+1d* to the
          *engagement roll*.
        }.gsub(/\s+/, ' ').strip
      },
      "Silver Tongues" => {
        description: %q{
          Each PC may add +1 action rating to *Command*, *Consort*, or *Sway*
          (up to a max rating of 3).
        }.gsub(/\s+/, ' ').strip,
        bonus: ['Command', 'Consort', 'Sway']
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
      },
      "War Dogs" => {
        description: %q{
          When you're at war (-3 faction status), PCs get *+1d* to *vice* rolls
          and still get two downtime actions, instead of just one.
        }.gsub(/\s+/, ' ').strip
      },
      "Vipers" => {
        description: %q{
          When you acquire or craft poisons, you get +1 result level to your
          roll. When you employ a poison, you are specially prepared to be
          immune to its effects.
        }
      },
      "Zealotry" => {
        description: %q{
          Your cohorts have abandoned their reason to devote themselves to the
          cult. They will undertake any service, no matter how dangerous or
          strange. They gain *+1d* to rolls against enemies of the faith.
        }.gsub(/\s+/, ' ').strip
      }
    }
  end

  def self.playbook_abilities
    {
      "Assassins" => [
        "Deadly", "Crow's Veil", "Emberdeath", "No Traces", "Patron",
        "Predators", "Vipers"
      ],
      "Bravos" => [
        "Dangerous", "Blood Brothers", "Door Kickers", "Fiends",
        "Forged in the Fire", "Patron", "War Dogs"
      ],
      "Cult" => [
        "Chosen", "Anointed", "Bound in Darkness", "Conviction",
        "Glory Incarnate", "Sealed in Blood", "Zealotry"
      ],
      "Hawkers" => [
        "Silver Tongues", "Accord", "The Good Stuff", "Ghost Market",
        "High Society", "Hooked", "Patron"
      ],
      "Shadows" => [
        "Everyone Steals", "Pack Rats", "Slippery", "Synchronized",
        "Second Story", "Patron", "Ghost Echoes"
      ],
      "Smugglers" => [
        "Like Part of the Family", "All Hands", "Ghost Passage",
        "Just Passing Through", "Leverage", "Reavers", "Renegades"
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
    if name == "Veteran" and veteran_ability
      return {
        name: veteran_ability.name,
        veteran: true
      }
    else
      return {
        name: name,
        veteran: false
      }
    end
  end
end
