# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spek::Picker do
  subject(:picker) { described_class.new finder:, kernel: }

  let(:kernel) { class_spy Kernel }
  let(:finder) { instance_double Spek::Finder }
  let(:fixture_path) { Bundler.root.join "spec/support/fixtures/test.gemspec" }

  describe ".call" do
    before { allow(finder).to receive(:call).and_return([specification]) }

    let(:specification) { Spek::Loader.call fixture_path }

    it "answers specification" do
      result = described_class.call("logger", finder:, kernel:)
      expect(result.success).to eq(specification)
    end
  end

  describe "#call" do
    context "with single selection" do
      before { allow(finder).to receive(:call).and_return([specification]) }

      let(:specification) { Spek::Loader.call fixture_path }

      it "answers computed specification" do
        result = picker.call "logger"
        expect(result.success).to eq(specification)
      end
    end

    context "with multiple selections" do
      before do
        allow(finder).to receive(:call).and_return([specification_a, specification_b])
        allow(kernel).to receive(:gets).and_return("2")
      end

      let(:specification_a) { Spek::Loader.call fixture_path }
      let(:specification_b) { Spek::Loader.call fixture_path }

      it "answers chosen specification" do
        result = picker.call "logger"
        expect(result.success).to eq(specification_b)
      end
    end

    context "with zero selections" do
      before { allow(finder).to receive(:call).and_return([]) }

      it "fails with message" do
        result = picker.call "test"
        expect(result.failure).to eq("Unknown or uninstalled gem: test.")
      end
    end
  end
end
