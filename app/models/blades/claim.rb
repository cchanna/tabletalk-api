class Blades::Claim < ApplicationRecord
  validates :row, :column, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }

  belongs_to :crew

  def self.claims_descriptions
    {
      "Covert Drops" => %q{
        *+2 coin* for espionage or sabotage
      },
      "Gambling Den" => den,
      "Halfway" => den,
      "Infirmary" => %q{
        *+1d* to healing rolls
      },
      "Informants" => %q{
        *+1d* gather info for scores
      },
      "Interrogation Chamber" => %q{
        *+1d* to Command and Sway on site
      },
      "Krii Farm" => %q{
        Body disposal, *+1d* to reduce heat after killing
      },
      "Lookouts" => %q{
        *+1d* to Survey or Hunt on your turf
      },
      "Loyal Fence" => %q{
        *+2 coin* for burglary or robbery
      },
      "Secret Pathways" => %q{
        *+1d* engagement for stealth plans
      },
      "Tavern" => %q{
        *+1d* to Consort and Sway on site
      },
    }
  end

  def self.playbook_claims
    {
      "Shadows" => {
        claims: [
          ["Interrogation Chamber", "Turf", "Loyal Fence", "Gambling Den", "Tavern"],
          ["Halfway", "Informants", "Lair", "Turf", "Lookouts"],
          ["Krii Farm", "Infirmary", "Covert Drops", "Turf", "Secret Pathways"]
        ],
        horizontal: [
          [true, true, false, true],
          [true, true, true, true],
          [true, false, true, true]
        ],
        vertical: [
          [true, false, true, true, true],
          [true, true, true, false, true]
        ]
      }
    }
  end

  def name
    pb = self.class.playbook_claims[crew.playbook]
    return nil unless pb
    return pb[:claims][row][column]
  end

  def description
    return self.class.claims_descriptions[name]
  end

  def self.map claims, playbook
    claims_result = []
    pb = playbook_claims[playbook]
    unless pb
      return {
        claims: [[nil] * 5] * 3,
        horizontal: [[true] * 4] * 3,
        vertical: [[true] * 5] * 2
      }
    end
    return [[nil] * 5] * 3 unless pb
    for r in 0..2 do
      row = []
      for c in 0..4 do
        description = claims_descriptions[pb[:claims][r][c]]
        description.gsub!(/\s+/, ' ').strip! if description
        entry = {
          name: pb[:claims][r][c],
          description: description,
          owned: false
        }
        claim = claims.find_by row: r, column: c
        entry[:owned] = true if claim
        row.push entry
      end
      claims_result.push row
    end
    result = {
      claims: claims_result,
      vertical: pb[:vertical],
      horizontal: pb[:horizontal]
    }
    return result
  end

private

  def self.den
    "(Tier roll) - Heat = coin in downtime"
  end

end
