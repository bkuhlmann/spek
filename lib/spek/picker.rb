# frozen_string_literal: true

require "dry/monads"

module Spek
  # Picks a gem specification.
  class Picker
    include Dry::Monads[:result]

    def self.call(name, ...) = new(...).call name

    def initialize finder: Finder.new, kernel: Kernel
      @finder = finder
      @kernel = kernel
    end

    def call name
      specifications = finder.call name

      case specifications.size
        when 1 then Success specifications.first
        when 2.. then Success choose(specifications)
        else Failure "Unknown or uninstalled gem: #{name}."
      end
    end

    def choose specifications
      specifications.each.with_index 1 do |specification, index|
        kernel.puts "#{index}. #{specification.named_version}"
      end

      kernel.puts "\nPlease enter gem selection:"
      ARGV.clear
      specifications[kernel.gets.chomp.to_i - 1]
    end

    private

    attr_reader :finder, :kernel
  end
end
