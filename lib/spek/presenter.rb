# frozen_string_literal: true

require "forwardable"
require "refinements/arrays"
require "refinements/pathnames"
require "refinements/strings"
require "versionaire"

module Spek
  # Enhances the default Ruby Gems specification.
  class Presenter
    extend Forwardable

    using Refinements::Arrays
    using Refinements::Strings
    using Refinements::Pathnames
    using Versionaire::Cast

    delegate %i[
      bindir
      executables
      extra_rdoc_files
      files
      license
      metadata
      name
      platform
      require_paths
      required_ruby_version
      runtime_dependencies
      summary
    ] => :record

    def initialize record
      @record = record
    end

    def allowed_push_key = metadata.fetch "allowed_push_key", "rubygems_api_key"

    def allowed_push_host = metadata.fetch "allowed_push_host", ::Gem::DEFAULT_HOST

    def authors = Array record.author

    def certificate_chain = Array(record.cert_chain).map { |path| Pathname path.to_s }

    def documentation_url = metadata.fetch "documentation_uri", ""

    def emails = Array record.email

    def funding_url = metadata.fetch "funding_uri", ""

    def homepage_url = String record.homepage

    def issues_url = metadata.fetch "bug_tracker_uri", ""

    def label = metadata.fetch "label", "Undefined"

    def labeled_summary(delimiter: " - ") = [label, summary].compress.join delimiter

    def labeled_version = "#{label} #{version}"

    def named_version = "#{name} #{version}"

    def package_path = Pathname("tmp").join package_name

    def package_name = "#{name}-#{version}.gem"

    def rubygems_mfa? = metadata.fetch("rubygems_mfa_required", "false").to_bool

    def signing_key = Pathname record.signing_key.to_s

    def source_path = Pathname record.full_gem_path

    def source_url = metadata.fetch "source_code_uri", ""

    def version = Version record.version.to_s

    def versions_url = metadata.fetch "changelog_uri", ""

    private

    attr_reader :record
  end
end
