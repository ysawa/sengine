# -*- coding: utf-8 -*-

class Point
  # Point means a position in a board.
  # It is just an array as [x, y].
  # x: 1 to 9
  # y: 1 to 9
  KEY_NAMES = %w(x y)
  attr_reader *KEY_NAMES

  def initialize(x, y)
    @x, @y = x, y
  end

  def mongoize
    [x, y]
  end

  class << self

    # Get the object as it was stored in the database, and instantiate
    # this custom class from it.
    def demongoize(object)
      Point.new(*object)
    end

    # Takes any possible object and converts it to how it would be
    # stored in the database.
    def mongoize(object)
      case object
      when Point
        object.mongoize
      when Hash
        point_map = object.stringify_keys
        KEK_NAMES.collect { |key| point_map[key] }
      else
        object
      end
    end

    # Converts the object that was supplied to a criteria and converts it
    # into a database friendly form.
    def evolve(object)
      case object
      when Point
        object.mongoize
      else
        object
      end
    end
  end
end
