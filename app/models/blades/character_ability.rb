class Blades::CharacterAbility < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }

  belongs_to :character

  def self.get name
    abilities[name.to_sym]
  end

  def self.playbook playbook
    return playbook_abilities.map do |a|
      get a
    end
  end

  def self.compare a, b, playbook_name
    pb = playbook_abilities[playbook_name.to_sym]
    return 0 if a == b
    return a <=> b unless pb
    if pb.include? a
      return -1 unless pb.include? b
      a_index = pb.find_index a
      b_index = pb.find_index b
      return -1 if a_index < b_index
      return 1 if a_index > b_index
    else
      return 1 if pb.include? b
      return -1 if a < b
      return 1 if a > b
    end
    return 0
  end

  def <=> other
    pb = self.class.playbook_abilities[self.character.playbook]
    return 0 if self == other
    return self <=> other unless pb
    if veteran
      return -1 unless other.veteran
      self_index = pb.find_index name
      other_index = pb.find_index other.name
      return self_index <=> other_index
    else
      return 1 if other.veteran
      return name <=> other.name
    end
    return 0
  end

  def to_json
    return {
      name: name,
      veteran: veteran
    }
  end

  def vigor
    ability = self.class.abilities[name]
    return 0 unless ability
    return ability[:vigor]
  end


  def self.abilities
    {
      "Ambush" => {
        description: %q{
          When you attack from hiding or spring a trap, you get *+1d*.
        }
      },
      "Battleborn" => {
        description: %q{
          You may expend your *special armor* to reduce harm from an attack in
          combat or to *push yourself* during a fight.
        }
      },
      "Bodyguard" => {
        description: %q{
          When you *protect* a teammate, take *+1d* to your resistance roll.
          When you *gather info* to anticipate possible threats in the current
          situation, you get *+1 effect*.
        }
      },
      "Calculating" => {
        description: %q{
          Due to your careful planning, during *downtime*, you may give
          yourself or another crew member +1 downtime action.
        }
      },
      "Cloak & Dagger" => {
        description: %q{
          When you use a disguise or other form of covert misdirection you get
          *+1d* to rolls to confuse or deflect suspicion. When you throw off
          your disguise, the resulting surprise gives you the initiative in
          the situation.
        }
      },
      "Connected" => {
        description: %q{
          During *downtime*, you get *+1 result level* when you make *acquire
          asset*, *gather info*, or *reduce heat* rolls.
        }
      },
      "Daredevil" => {
        description: %q{
          When you roll a desperate action, you get *+1d* yo your roll if you
          also take *-1d* to any resistance rolls against consequences from your
          actions.
        }
      },
      "The Devil's Footsteps" => {
        description: %q{
          When you *push yourself*, choose one of the following additional
          benefits: _perform a feat of athletics that verges on the
          superhuman_—_maneuver to confuse your enemies so they mistakenly
          attack each other_.
        }
      },
      "Expertise" => {
        description: %q{
          Choose one of your action ratings. When you lead a *group action*
          using that action, you can suffer only 1 stress at most regardless of
          the number of failed rolls.
        }
      },
      "Foresight" => {
        description: %q{
          Two times per score you can *assist* a teammate without paying
          stress. Tell us how you prepared for this.
        }
      },
      "Functioning Vice" => {
        description: %q{
          When you indulge your *vice*, you may adjust the outcome by 1 or 2
          (up or down). An ally who joins in your vice may do the same.
        }
      },
      "Ghost Contract" => {
        description: %q{
          When you shake on a deal, you and your partner—human or
          otherwise—both bear a mark of your oath. If either breaks the
          contract, they take level 3 harm, "Cursed".
        }
      },
      "Ghost Fighter" => {
        description: %q{
          You may imbue your hands, melee weapons, or tools with spirit
          energy. You gain *potency* in combat vs. the supernatural. You may
          grapple with spirits to restrain and capture them.
        }
      },
      "Ghost Veil" => {
        description: %q{
          You may shift partially into the ghost field, becoming shadowy and
          insubstantial for a few moments. Take 2 stress when you shift, plus 1
          stress for each feature: _It lasts for a few minutes rather than a few
          moments_—_you are invisible rather than shadowy_—_you may float
          through the air like a ghost_.
        }
      },
      "Ghost Voice" => {
        description: %q{
          You know the secret method to interact with a ghost or demon as if
          it was a normal human, regardless of how wild or feral it appears.
          You gain *potency* when communicating with the supernatural.
        }
      },
      "Infiltrator" => {
        description: %q{
          You are not effected by *quality* or *Tier* when you bypass security
          measures.
        }
      },
      "Jail Bird" => {
        description: %q{
          When *incarcerated*, your wanted level counts as 1 less, your Tier
          as 1 more, and you gain +1 faction status with a faction you help on
          the inside (in addition to your incarceration roll).
        }
      },
      "Leader" => {
        description: %q{
          When you *Command* a *cohort* in combat, they continue to fight when
          they would otherwise *break* (they're not taken out when they suffer
          level 3 harm). They gain *potency* and *1 armor*.
        }
      },
      "Like Looking into a Mirror" => {
        description: %q{
          You can always tell when someone is lying to you.
        }
      },
      "A Little Something on the Side" => {
        description: %q{
          At the end of each downtime phase, you earn *+2 stash*.
        }
      },
      "Mastermind" => {
        description: %q{
          You may expend your *special armor* to protect a teammate, or to
          *push yourself* when you gather information or work on a long-term
          project.
        }
      },
      "Mesmerism" => {
        description: %q{
          When you *sway* someone, you may cause them to forget that it's
          happened until they next interact with you.
        }
      },
      "Mule" => {
        description: %q{
          Your load limits are higher. Light: 5. Normal: 7. Heavy: 8.
        },
        load: 2
      },
      "Not to be Trifled With" => {
        description: %q{
          You can *push yourself* to do one of the following: _perform a feat
          of physical force that verges on the superhuman_—_engage a small
          gang on equal footing in close combat_.
        }
      },
      "Reflexes" => {
        description: %q{
          When there's a question about who acts first, the answer is you (two
          characters with Reflexes act simultaneously).
        }
      },
      "Rook's Gambit" => {
        description: %q{
          Take *2 stress* to roll your best action rating while performing a
          different action. Say how you adapt your skill to this use.
        }
      },
      "Savage" => {
        description: %q{
          When you unleash physical violence, it's especially frightening.
          When you *Command* a frightened target, take *+1d*.
        }
      },
      "Shadow" => {
        description: %q{
          You may expend your *special armor* to resist a consequence from
          detection or security measures, or to *push yourself* for a feat of
          athletics or stealth.
        }
      },
      "Subterfuge" => {
        description: %q{
          subterfuge.
          You may expend your *special armor* to resist a consequence from
          suspsicion or persuasion, or to *push yourself* for
        }
      },
      "Trust in Me" => {
        description: %q{
          You get *+1d* vs. a target with whom you have an intimate
          relationship.
        }
      },
      "Vigorous" => {
        description: %q{
          You recover from harm faster. Permanently fill in one of your
          healing clock segments. Take *+1d* to healing treatment rolls
        },
        vigor: 1
      },
      "Weaving the Web" => {
        description: %q{
          You gain *+1d* to *Consort* when you *gather information* on a
          target for a score. You get *+1d* to the *engagement roll* for
          that operation.
        }
      },
    }
  end

  def self.playbook_abilities
    {
        "Cutter" => [
          "Battleborn", "Bodyguard", "Ghost Fighter", "Leader", "Mule",
          "Not to be Trifled With", "Savage", "Vigorous"
        ],
        "Lurk" => [
          "Infiltrator", "Ambush", "Daredevil", "The Devil's Footsteps",
          "Expertise", "Ghost Veil", "Reflexes", "Shadow"
        ],
        "Slide" => [
          "Rook's Gambit", "Cloak & Dagger", "Ghost Voice",
          "A Little Something on the Side", "Like Looking into a Mirror",
          "Mesmerism", "Subterfuge", "Trust in Me",
        ],
        "Spider" => [
          "Foresight", "Calculating", "Connected", "Functioning Vice",
          "Ghost Contract", "Jail Bird", "Mastermind", "Weaving the Web",
        ],
    }
  end
end
