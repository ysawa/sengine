# -*- coding: utf-8 -*-

module SBot
  class Move
    ATTRIBUTES = %w(from_point number put reverse role sente to_point)
    attr_accessor *ATTRIBUTES
    attr_accessor :take_role

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

    def initialize_move(sente, role, from_point, to_point, reverse, take_role)
      @sente, @role, @from_point, @to_point, @reverse, @take_role, @put =
          sente, role, from_point, to_point, reverse, take_role, false
    end

    def initialize_put(sente, role, to_point)
      @sente, @role, @to_point, @put =
          sente, role, to_point, true
    end

    def move?
      !put?
    end

    def priority
      if @take_role
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
      @take_role
    end

    class << self
      def new_move(sente, role, from_point, to_point, reverse, take_role)
        move = new
        move.initialize_move(sente, role, from_point, to_point, reverse, take_role)
      end

      def new_put(sente, role, to_point)
        move = new
        move.initialize_put(sente, role, to_point)
      end
    end
  end
end
