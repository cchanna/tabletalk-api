module Blades
  def self.table_name_prefix
    'blades_'
  end

  def self.load as:
    data = {}

    data[:library] = {
      crew: {
        abilities: {
          def: CrewAbility.abilities,
          playook: CrewAbility.playbook_abilities
        }
      },
      character: {
        abilities: {
          def: Ability.abilities,
          playbook: Ability.playbook_abilities
        }
      }
    }


    result = Character.load as: as
    return result if result.failed?
    data[:characters] = result.value

    result = Crew.load as: as
    result result if result.failed?
    data[:crews] = result.value

    return Result.success data
  end
end
