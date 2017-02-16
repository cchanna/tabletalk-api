module Blades
  def self.table_name_prefix
    'blades_'
  end

  def self.load as:
    data = {}

    result = Character.load as: as
    return result if result.failed?
    data[:characters] = result.value

    result = Crew.load as: as
    result result if result.failed?
    data[:crews] = result.value
    
    return Result.success data
  end
end
