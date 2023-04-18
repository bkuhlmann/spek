# frozen_string_literal: true

require "spec_helper"

RSpec.describe Spek::Presenter do
  using Versionaire::Cast

  subject(:presenter) { described_class.new specification }

  let :specification do
    Gem::Specification.new do |spec|
      spec.name = "test"
      spec.version = "0.0.0"
      spec.authors = "Jill Smith"
      spec.summary = "A test summary."
    end
  end

  describe ".with_default" do
    it "answers defaults when no record is given" do
      expect(described_class.with_default.named_version).to eq("0.0.0")
    end

    it "answers defaults when unknown type is given" do
      expect(described_class.with_default(Object.new).named_version).to eq("0.0.0")
    end

    it "answers specifics when valid record is given" do
      expect(described_class.with_default(specification).named_version).to eq("test 0.0.0")
    end
  end

  describe "#allowed_push_host" do
    it "answers RubyGems host with no metadata" do
      expect(presenter.allowed_push_host).to eq("https://rubygems.org")
    end

    it "answers custom host with metadata" do
      specification.metadata["allowed_push_host"] = "https://push.example.com"
      expect(presenter.allowed_push_host).to eq("https://push.example.com")
    end
  end

  describe "#allowed_push_key" do
    it "answers RubyGems key with no metadata" do
      expect(presenter.allowed_push_key).to eq("rubygems_api_key")
    end

    it "answers custom key with metadata" do
      specification.metadata["allowed_push_key"] = "test"
      expect(presenter.allowed_push_key).to eq("test")
    end
  end

  describe "#authors" do
    it "answers array with authors" do
      expect(presenter.authors).to contain_exactly("Jill Smith")
    end

    it "answers empty array with no authors" do
      specification.author = nil
      expect(presenter.authors).to eq([])
    end
  end

  describe "#banner" do
    it "answers label, version, and summary" do
      expect(presenter.banner).to eq("Undefined 0.0.0: A test summary.")
    end

    it "answers label, verison, and summary with custom delimiter" do
      expect(presenter.banner(delimiter: " - ")).to eq("Undefined 0.0.0 - A test summary.")
    end
  end

  describe "#bindir" do
    it "answers default directory" do
      expect(presenter.bindir).to eq("bin")
    end

    it "answers custom directory" do
      specification.bindir = "exe"
      expect(presenter.bindir).to eq("exe")
    end
  end

  describe "#certificate_chain" do
    it "answers empty array when undefined" do
      expect(presenter.certificate_chain).to eq([])
    end

    it "answers array of custom pathnames" do
      specification.cert_chain = Gem.default_cert_path
      expect(presenter.certificate_chain).to contain_exactly(Pathname(Gem.default_cert_path))
    end
  end

  describe "#documentation_url" do
    it "answers empty string when missing" do
      expect(presenter.documentation_url).to eq("")
    end

    it "answers custom URL" do
      specification.metadata["documentation_uri"] = "https://example.com/projects/test"
      expect(presenter.documentation_url).to eq("https://example.com/projects/test")
    end
  end

  describe "#emails" do
    it "answers empty array with no email" do
      expect(presenter.emails).to eq([])
    end

    it "answers array with emails" do
      specification.email = ["jill@example.com", "jon@example.com"]
      expect(presenter.emails).to contain_exactly("jill@example.com", "jon@example.com")
    end
  end

  describe "#executables" do
    it "answers empty array when undefined" do
      expect(presenter.executables).to eq([])
    end

    it "answers custom executables" do
      specification.executables << "test"
      expect(presenter.executables).to contain_exactly("test")
    end
  end

  describe "#extra_rdoc_files" do
    it "answers empty array when undefined" do
      expect(presenter.extra_rdoc_files).to eq([])
    end

    it "answers custom array" do
      specification.extra_rdoc_files = Dir["README*", "LICENSE*"]
      expect(presenter.extra_rdoc_files).to eq(["README.adoc", "LICENSE.adoc"])
    end
  end

  describe "#files" do
    it "answers empty array when undefined" do
      expect(presenter.files).to eq([])
    end

    it "answers custom array" do
      specification.files = Dir["*.gemspec"]
      expect(presenter.files).to eq(["spek.gemspec"])
    end
  end

  describe "#funding_url" do
    it "answers empty string when missing" do
      expect(presenter.funding_url).to eq("")
    end

    it "answers custom URL" do
      specification.metadata["funding_uri"] = "https://example.com/projects/test/sponsor"
      expect(presenter.funding_url).to eq("https://example.com/projects/test/sponsor")
    end
  end

  describe "#homepage_url" do
    it "answers empty string when missing" do
      expect(presenter.homepage_url).to eq("")
    end

    it "answers URL with homepage" do
      specification.homepage = "https://example.com/projects/test"
      expect(presenter.homepage_url).to eq("https://example.com/projects/test")
    end
  end

  describe "#issues_url" do
    it "answers empty string when missing" do
      expect(presenter.issues_url).to eq("")
    end

    it "answers custom URL" do
      specification.metadata["bug_tracker_uri"] = "https://example.com/projects/test/issues"
      expect(presenter.issues_url).to eq("https://example.com/projects/test/issues")
    end
  end

  describe "#label" do
    it "answers undefined label when missing" do
      expect(presenter.label).to eq("Undefined")
    end

    it "answers custom label with metadata" do
      specification.metadata["label"] = "Test"
      expect(presenter.label).to eq("Test")
    end
  end

  describe "#labeled_summary" do
    it "answers label and summary" do
      expect(presenter.labeled_summary).to eq("Undefined - A test summary.")
    end

    it "answers label and summary with custom delimiter" do
      expect(presenter.labeled_summary(delimiter: ": ")).to eq("Undefined: A test summary.")
    end
  end

  describe "#labeled_version" do
    it "answers default label and version" do
      expect(presenter.labeled_version).to eq("Undefined 0.0.0")
    end

    it "answers custom label and version" do
      specification.metadata["label"] = "Test"
      specification.version = "1.2.3"

      expect(presenter.labeled_version).to eq("Test 1.2.3")
    end

    it "answers version only when label is missing" do
      specification.metadata["label"] = nil
      expect(presenter.labeled_version).to eq("0.0.0")
    end

    it "answers default label and version when version is missing" do
      allow(specification).to receive(:version).and_return nil
      expect(presenter.labeled_version).to eq("Undefined 0.0.0")
    end

    it "answers version only when name and version is missing" do
      specification.metadata["label"] = nil
      allow(specification).to receive(:version).and_return nil

      expect(presenter.labeled_version).to eq("0.0.0")
    end
  end

  describe "#license" do
    it "answers nil when undefined" do
      expect(presenter.license).to be(nil)
    end

    it "answers custom license" do
      specification.license = "Hippocratic-3.0"
      expect(presenter.license).to eq("Hippocratic-3.0")
    end
  end

  describe "#metadata" do
    it "answers empty hash when missing" do
      expect(presenter.metadata).to eq({})
    end

    it "answers hash with metadata" do
      specification.metadata["test"] = "example"
      expect(presenter.metadata).to eq("test" => "example")
    end
  end

  describe "#name" do
    it "answers name" do
      expect(presenter.name).to eq("test")
    end
  end

  describe "#named_version" do
    it "answers default name and version" do
      expect(presenter.named_version).to eq("test 0.0.0")
    end

    it "answers version only when name is missing" do
      specification.name = nil
      expect(presenter.named_version).to eq("0.0.0")
    end

    it "answers name and default version when version is missing" do
      allow(specification).to receive(:version).and_return nil
      expect(presenter.named_version).to eq("test 0.0.0")
    end

    it "answers version only when name and version is missing" do
      specification.name = nil
      allow(specification).to receive(:version).and_return nil

      expect(presenter.named_version).to eq("0.0.0")
    end
  end

  describe "#package_name" do
    it "answers default file name" do
      expect(presenter.package_name).to eq("test-0.0.0.gem")
    end

    it "answers version only when name is missing" do
      specification.name = nil
      expect(presenter.package_name).to eq("0.0.0.gem")
    end

    it "answers name and default version when version is missing" do
      allow(specification).to receive(:version).and_return nil
      expect(presenter.package_name).to eq("test-0.0.0.gem")
    end

    it "answers version only when name and version is missing" do
      specification.name = nil
      allow(specification).to receive(:version).and_return nil

      expect(presenter.package_name).to eq("0.0.0.gem")
    end
  end

  describe "#package_path" do
    it "answers relative path" do
      expect(presenter.package_path).to eq(Pathname("tmp/test-0.0.0.gem"))
    end
  end

  describe "#platform" do
    it "answers default platform" do
      expect(presenter.platform).to eq("ruby")
    end

    it "answers custom platform" do
      specification.platform = Gem::Platform::CURRENT
      expect(presenter.platform).to be_a(Gem::Platform)
    end
  end

  describe "#require_paths" do
    it "answers default path" do
      expect(presenter.require_paths).to eq(["lib"])
    end

    it "answers custom array" do
      specification.require_paths = "lib", "other"
      expect(presenter.require_paths).to contain_exactly("lib", "other")
    end
  end

  describe "#required_ruby_version" do
    it "answers default requirement when undefined" do
      expect(presenter.required_ruby_version).to eq(Gem::Requirement.new)
    end

    it "answers custom requirement" do
      specification.required_ruby_version = "3.0"
      expect(presenter.required_ruby_version).to eq(Gem::Requirement.new(["= 3.0"]))
    end
  end

  describe "#rubygems_mfa?" do
    it "answers false" do
      expect(presenter.rubygems_mfa?).to be(false)
    end

    it "answers true with metadata" do
      specification.metadata["rubygems_mfa_required"] = "true"
      expect(presenter.rubygems_mfa?).to be(true)
    end
  end

  describe "#runtime_dependencies" do
    it "answers empty array when undefined" do
      expect(presenter.runtime_dependencies).to eq([])
    end

    it "answers custom dependencies" do
      specification.add_dependency "refinements", "~> 1.0"

      expect(presenter.runtime_dependencies).to contain_exactly(
        Gem::Dependency.new("refinements", "~> 1.0", :runtime)
      )
    end
  end

  describe "#signing_key" do
    it "answers empty pathname when undefined" do
      expect(presenter.signing_key).to eq(Pathname(""))
    end

    it "answers custom path" do
      specification.signing_key = Gem.default_key_path
      expect(presenter.signing_key.to_s).to include("gem-private_key.pem")
    end
  end

  describe "#source_path" do
    it "answers gem path" do
      expect(presenter.source_path.to_s).to match(%r(gems/test-0\.0\.0))
    end

    it "answers a pathname" do
      expect(presenter.source_path).to be_a(Pathname)
    end
  end

  describe "#source_url" do
    it "answers empty string when missing" do
      expect(presenter.source_url).to eq("")
    end

    it "answers custom URL" do
      specification.metadata["source_code_uri"] = "https://example.com/projects/test/source"
      expect(presenter.source_url).to eq("https://example.com/projects/test/source")
    end
  end

  describe "#summary" do
    it "answers gem summary" do
      expect(presenter.summary).to eq("A test summary.")
    end
  end

  describe "#version" do
    it "answers version" do
      expect(presenter.version).to eq(Version("0.0.0"))
    end
  end

  describe "#versions_url" do
    it "answers empty string when missing" do
      expect(presenter.versions_url).to eq("")
    end

    it "answers custom URL" do
      specification.metadata["changelog_uri"] = "https://example.com/projects/test/versions"
      expect(presenter.versions_url).to eq("https://example.com/projects/test/versions")
    end
  end
end
