# -*- coding: utf-8 -*-

class Movement
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  field :from_point, type: Point
  field :number, type: Integer
  field :put, type: Boolean, default: false
  field :reverse, type: Boolean, default: false
  field :role, type: Integer # positive integer
  field :sente, type: Boolean
  field :to_point, type: Point
  belongs_to :board # the board applied this movement to
  belongs_to :game
  has_many :pushes, inverse_of: :pushable

  validate :validate_from_point_presence
  validate :validate_to_point_presence
  validate :validate_reverse_can_be_taken
  validates_presence_of :role

  def gote?
    !sente?
  end

  def move
    !put
  end

  def move?
    !put?
  end

  def role=(integer)
    if integer.present?
      write_attribute(:role, integer)
    else
      write_attribute(:role, nil)
    end
  end

  def role_string
    if self.role
      Piece::ROLE_STRINGS[self.role]
    end
  end

  def role_string=(string)
    if string.present?
      write_attribute(:role, Piece::ROLE_STRINGS.index(string))
    else
      write_attribute(:role, nil)
    end
  end

  def to_json
    attrs = to_json_attributes
    attrs.to_json
  end

  def to_json_attributes
    attrs = attributes.dup
    point = attrs['from_point']
    if point
      attrs['from_point'] = [point['x'], point['y']]
    end
    point = attrs['to_point']
    if point
      attrs['to_point'] = [point['x'], point['y']]
    end
    role_value = attrs['role']
    if role_value
      attrs.delete('role')
      attrs['role_string'] = Piece::ROLE_STRINGS[role_value]
    end
    attrs
  end

  def validate_from_point_presence
    if move? && !from_point?
      errors.add(:from_point, 'should be taken')
      return false
    elsif put? && from_point?
      errors.add(:from_point, 'should not be taken')
      return false
    end
    true
  end

  def validate_reverse_can_be_taken
    return true unless reverse?
    if put?
      errors.add(:reverse, 'cannot be taken')
      return false
    end
    true
  end

  def validate_to_point_presence
    unless to_point?
      errors.add(:to_position, 'should be taken')
      return false
    end
    true
  end

  class << self
    def after(number)
      criteria.where(:number.gt => number.to_i)
    end
  end
end
