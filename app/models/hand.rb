# -*- coding: utf-8 -*-

class Hand
  # Hand means the numbers of pieces in hands of players

  KEY_NAMES = %w(fu ky ke gi ki ka hi ou)
  attr_reader *KEY_NAMES

  def generate_name(key)
    case key
    when 0
      nil
    when Integer
      KEY_NAMES[key - 1]
    else
      key.to_s
    end
  end

  def initialize(*objects)
    if objects[1]
      import_from_array(objects)
    else
      object = objects[0]
      case object
      when Array
        import_from_array(object)
      when Hash
        import_from_hash(object)
      when nil
        import_from_array([])
      end
    end
    nil
  end

  def method_missing(method_name, *args)
    if method_name.to_s =~ /^(\w{2})=$/
      value = args[0]
      value = 0 unless value
      return instance_variable_set("@#{$1}", value)
    end
    super
  end

  def mongoize
    result = {}
    KEY_NAMES.each do |name|
      result[name] = instance_variable_get("@#{name}")
    end
    result
  end

  def [](key)
    name = generate_name key
    if name
      instance_variable_get("@#{name}")
    end
  end

  def []=(key, value)
    name = generate_name key
    value = 0 unless value
    instance_variable_set("@#{name}", value)
  end

  class << self

    # Get the object as it was stored in the database, and instantiate
    # this custom class from it.
    def demongoize(object)
      new(object)
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

private

  def import_from_array(array)
    KEY_NAMES.each_with_index do |name, i|
      value = array[i + 1]
      value = 0 unless value
      instance_variable_set("@#{name}", value)
    end
  end

  def import_from_hash(hash)
    hash = hash.stringify_keys
    KEY_NAMES.each do |name|
      value = hash[name]
      value = 0 unless value
      instance_variable_set("@#{name}", value)
    end
  end
end
