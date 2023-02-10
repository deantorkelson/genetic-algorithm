require 'colorize'

module Entities
  class Agent
    attr_accessor :name, :genes

    def initialize(name:)
      @name = name
      @genes = {}
      # eventually this should have sight (view distance)
      # also speed (turn priority)
    end

    def to_s
      @name
    end
  end
end