# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spek::Finder do
  subject(:finder) { described_class.new }

  describe ".call" do
    it "answers matching specifications" do
      specifications = described_class.call "refinements"
      names = specifications.map(&:name).uniq

      expect(names).to contain_exactly("refinements")
    end
  end

  describe "#call" do
    it "answers matching specifications" do
      specifications = finder.call "refinements"
      names = specifications.map(&:name).uniq

      expect(names).to contain_exactly("refinements")
    end

    it "answers empty array with no matches" do
      specifications = finder.call "unknown"
      expect(specifications).to eq([])
    end
  end
end
