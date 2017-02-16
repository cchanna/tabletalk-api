class Blades::Claim < ApplicationRecord
  validates :row, :column, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }

  den = "(Tier roll) - Heat = coin in downtime"

  def self.claims
    [
      "Covert Drops": %q{
        *+2 coin* for espionage or sabotage
      },
      "Gambling Den": den,
      "Halfway": den,
      "Infirmary": %q{
        *+1d* to healing rolls
      },
      "Informants": %q{
        *+1d* gather info for scores
      },
      "Interrogation Chamber": %q{
        *+1d* to Command and Sway on site
      },
      "Krii Farm": %q{
        Body disposal, *+1d* to reduce heat after killing
      },
      "Lookouts": %q{
        *+1d* to Survey or Hunt on your turf
      },
      "Loyal Fence": %q{
        *+2 coin* for burglary or robbery
      },
      "Secret Pathways": %q{
        *+1d* engagement for stealth plans
      },
      "Tavern": %q{
        *+1d* to Consort and Sway on site
      },
    ]
  end

  def self.playbook_claims
    {
      "Shadows": [
        ["Interrogation Chamber", "Turf", "Loyal Fence", "Gambling Den", "Tavern"],
        ["Halfway", "Informants", "Lair", "Turf", "Lookouts"],
        ["Krii Farm", "Infirmary", "Covert Drops", "Turf", "Secret Pathways"]
      ]
    }
  end

  belongs_to :crew

  def self.map claims, playbook:
    result = []
    pb = playbook_claims[playbook]
    return [[nil] * 5] * 3 unless pb
    for r in 1..3 do
      row = []
      for c in 1..5 do
        entry = {
          name: pb[r][c],
          description: claims[pb[r][c]],
          owned: false
        }
        claim = claims.find_by row: r, column: c
        entry[:owned] = true if claim
        row.push entry
      end
      result.push row
    end
    return result
  end
end
