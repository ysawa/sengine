# -*- coding: utf-8 -*-

class Point
  # Point means a position in a board.
  # It is just an array as [x, y].
  # x: 1 to 9
  # y: 1 to 9
  KEY_NAMES = %w(x y)
  attr_reader *KEY_NAMES

  def generate_name(key)
    case key
    when 0
      'x'
    when 1
      'y'
    else
      key.to_sym
    end
  end

  def initialize(*objects)
    if objects[1]
      @x, @y = objects
    else
      object = objects[0]
      case object
      when Array
        @x, @y = object
      when Hash
        object = object.stringify_keys
        @x = object['x']
        @y = object['y']
      end
    end
    @x = @x.to_i if @x
    @y = @y.to_i if @y
    nil
  end

  def mongoize
    { 'x' => x, 'y' => y }
  end

  def x=(x)
    @x = x
    @x = @x.to_i if @x
  end

  def y=(y)
    @y = y
    @y = @y.to_i if @y
  end

  def [](key)
    name = generate_name key
    instance_variable_get("@#{name}")
  end

  def []=(key, value)
    name = generate_name key
    value = value.to_i if value
    instance_variable_set("@#{name}", value)
  end

  class << self

    # Get the object as it was stored in the database, and instantiate
    # this custom class from it.
    def demongoize(object)
      new(*object)
    end

    # Takes any possible object and converts it to how it would be
    # stored in the database.
    def mongoize(object)
      case object
      when Point
        object.mongoize
      when Array, Hash
        new(object).mongoize
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
