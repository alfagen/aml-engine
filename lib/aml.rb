require 'archivable'

require "aml/engine"

module AML
  def self.table_name_prefix
    'aml_'
  end

  def self.default_status_key
    'default'
  end

  def self.default_status
    AML::Status.find_by(key: default_status_key) || raise("Default state (#{default_status_key}) is not found")
  end
end
