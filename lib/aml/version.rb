# You must install semver before bundle
#
require 'semver'

module AML
  def self.version
    SemVer.find
  end
  VERSION = version
end
