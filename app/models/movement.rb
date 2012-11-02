# -*- coding: utf-8 -*-

class Movement
  include Mongoid::Document
  include Mongoid::Timestamps
  field :from_point, type: Point
  field :number, type: Integer
  field :put, type: Boolean, default: false
  field :reverse, type: Boolean, default: false
  field :role, type: String
  field :role_value, type: Integer # positive integer
  field :sente, type: Boolean
  field :to_point, type: Point
  belongs_to :board # the board applied this movement to
  belongs_to :game

  validate :validate_from_point_presence
  validate :validate_to_point_presence
  validate :validate_reverse_can_be_taken

  def gote?
    !sente?
  end

  def move
    !put
  end

  def move?
    !put?
  end

  def role=(string)
    if string.present?
      write_attribute(:role, string)
      write_attribute(:role_value, Piece::ROLE_STRINGS.index(string))
    else
      write_attribute(:role, nil)
    end
  end

  def role_value=(integer)
    if integer.present?
      write_attribute(:role, Piece::ROLE_STRINGS[integer])
      write_attribute(:role_value, integer)
    else
      write_attribute(:role_value, nil)
    end
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
