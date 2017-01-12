module Blades
  def self.table_name_prefix
    'blades_'
  end

  def self.load as:
    data = {}
    result = Character.load as: as
    return result if result.failed?
    data[:characters] = result.value
    return Result.success data
  end
end
