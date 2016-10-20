class ResultValidator < ActiveModel::Validator
  def validate(die)
    unless die.sides and die.sides.include? die.result
      die.errors[:base] << "Result #{die.result} is invalid for #{die.kind}"
    end
  end
end

class Die < ApplicationRecord
  belongs_to :roll

  enum_accessor :kind, [
    :d6,
    :d4,
    :d8,
    :d10,
    :d12,
    :d20,
    :df
  ]

  def self.sides_for(die)
    case die.to_s
    when "d6"
      return (1..6).to_a
    when "d4"
      return (1..4).to_a
    when "d8"
      return (1..8).to_a
    when "d10"
      return (1..10).to_a
    when "d12"
      return (1..12).to_a
    when "d20"
      return (1..20).to_a
    when "df"
      return [-1, -1, 0, 0, 1, 1]
    end
  end

  def sides
    return Die.sides_for self.kind
  end


  validates :result, presence: true
  validates :kind, presence: true
  validates_with ResultValidator

  def self.roll(args)
    kind = args[:kind]
    return nil unless kind
    roll = args[:roll]
    return nil unless roll
    return Die.create kind: kind, roll: roll, result: roll_die(kind)
  end


private
  def self.roll_die die
    sides = Die.sides_for die
    return sides[rand 0...sides.count]
  end


end
