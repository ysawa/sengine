# -*- coding: utf-8 -*-

class Movement
  include Mongoid::Document
  include Mongoid::Timestamps
  field :sente, type: Boolean
  field :from_point, type: Point
  field :move, type: Boolean
  field :number, type: Integer
  field :put, type: Boolean
  field :reverse, type: Boolean
  field :role, type: String
  field :role_value, type: Integer
  field :to_point, type: Point
  belongs_to :board # the board applied this movement to
  belongs_to :game

  validate :validate_from_point_presence
  validate :validate_to_point_presence
  validate :validate_reverse_can_be_taken
  validate :validate_move_and_put_incompatibility

  def gote?
    !sente?
  end

  def role=(string)
    if string.present?
      write_attribute(:role, string)
      write_attribute(:role_value, Piece::ROLE_STRINGS.index(string))
    else
      write_attribute(:role, nil)
      write_attribute(:role_value, nil)
    end
  end

  def validate_from_point_presence
    if move? && !from_point?
      errors.add(:from_point, 'should be taken')
      return false
    elsif !move? && from_point?
      errors.add(:move, 'should be taken')
      return false
    end
    true
  end

  def validate_move_and_put_incompatibility
    if self.move == self.put
      errors.add(:put, 'is incompatible with move')
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
