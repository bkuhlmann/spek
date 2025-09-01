# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "spek"
  spec.version = "4.4.0"
  spec.authors = ["Brooke Kuhlmann"]
  spec.email = ["brooke@alchemists.io"]
  spec.homepage = "https://alchemists.io/projects/spek"
  spec.summary = "An enhanced gem specification wrapper."
  spec.license = "Hippocratic-2.1"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bkuhlmann/spek/issues",
    "changelog_uri" => "https://alchemists.io/projects/spek/versions",
    "homepage_uri" => "https://alchemists.io/projects/spek",
    "funding_uri" => "https://github.com/sponsors/bkuhlmann",
    "label" => "Spek",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/bkuhlmann/spek"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = "~> 3.4"
  spec.add_dependency "core", "~> 2.0"
  spec.add_dependency "dry-monads", "~> 1.9"
  spec.add_dependency "refinements", "~> 13.5"
  spec.add_dependency "versionaire", "~> 14.0"
  spec.add_dependency "zeitwerk", "~> 2.7"

  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir["*.gemspec", "lib/**/*"]
end
