# -*- coding: utf-8 -*-

class Hand
  # Hand means the numbers of pieces in hands of players

  KEY_NAMES = %w(fu ky ke gi ki ka hi ou)
  attr_reader *KEY_NAMES

  def initialize(fu, ky, ke, gi, ki, ka, hi, ou)
    @fu, @ky, @ke, @gi, @ki, @ka, @hi, @ou =
      fu, ky, ke, gi, ki, ka, hi, ou
  end

  def mongoize
    [nil, fu, ky, ke, gi, ki, ka, hi, ou]
  end

  class << self

    # Get the object as it was stored in the database, and instantiate
    # this custom class from it.
    def demongoize(object)
      hand_series = object[1,8]
      Hand.new(*hand_series)
    end

    # Takes any possible object and converts it to how it would be
    # stored in the database.
    def mongoize(object)
      case object
      when Hand
        object.mongoize
      when Hash
        hand_map = object.stringify_keys
        result = [nil]
        KEY_NAMES.each do |key|
          result << hand_map[key]
        end
        result
      else
        object
      end
    end

    # Converts the object that was supplied to a criteria and converts it
    # into a database friendly form.
    def evolve(object)
      case object
      when Hand
        object.mongoize
      else
        object
      end
    end
  end
end
