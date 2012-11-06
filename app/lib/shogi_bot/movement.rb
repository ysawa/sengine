# -*- coding: utf-8 -*-

module ShogiBot
  class Movement
    ATTRIBUTES = %w(from_point number put reverse role_value sente to_point)
    attr_accessor *ATTRIBUTES
    attr_accessor :take_role_value

    def attributes
      attrs = {}
      ATTRIBUTES.each do |key|
        attrs[key] = instance_variable_get("@#{key}")
      end
      attrs
    end

    def attributes=(attrs)
      attrs.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def gote?
      !sente?
    end

    def initialize(attrs = {})
      self.attributes = attrs
    end

    def move?
      !put?
    end

    def priority
      if @take_role_value
        10
      else
        0
      end
    end

    def put?
      @put
    end

    def reverse?
      @reverse
    end

    def sente?
      @sente
    end

    def take_piece?
      @take_role_value
    end
  end
end
