# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "spek"
  spec.version = "0.1.0"
  spec.authors = ["Brooke Kuhlmann"]
  spec.email = ["brooke@alchemists.io"]
  spec.homepage = "https://www.alchemists.io/projects/spek"
  spec.summary = "Enhances gem specifications with additional information and tooling."
  spec.license = "Hippocratic-3.0"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bkuhlmann/spek/issues",
    "changelog_uri" => "https://www.alchemists.io/projects/spek/versions",
    "documentation_uri" => "https://www.alchemists.io/projects/spek",
    "label" => "Spek",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/bkuhlmann/spek"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = "~> 3.1"
  spec.add_dependency "dry-monads", "~> 1.4"
  spec.add_dependency "refinements", "~> 9.2"
  spec.add_dependency "versionaire", "~> 10.1"
  spec.add_dependency "zeitwerk", "~> 2.5"

  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir["*.gemspec", "lib/**/*"]
end
