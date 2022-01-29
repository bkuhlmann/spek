# frozen_string_literal: true

require "spec_helper"

require "versionaire/cast"

RSpec.describe Spek::Versioner do
  using Refinements::Pathnames
  using Versionaire::Cast

  subject(:versioner) { described_class.new }

  include_context "with temporary directory"

  let(:fixture_path) { Bundler.root.join "spec/support/fixtures/test.gemspec" }
  let(:spec_path) { temp_dir.join "test.gemspec" }

  before { fixture_path.copy spec_path }

  describe ".call" do
    it "answers updated specification" do
      specification = described_class.call "1.2.3", spec_path
      expect(specification.version).to eq(Version("1.2.3"))
    end
  end

  describe "#call" do
    it "updates specification version" do
      versioner.call "1.2.3", spec_path
      expect(Spek::Loader.call(spec_path).version).to eq(Version("1.2.3"))
    end

    it "answers updated specification" do
      specification = versioner.call "1.2.3", spec_path
      expect(specification.version).to eq(Version("1.2.3"))
    end
  end
end
