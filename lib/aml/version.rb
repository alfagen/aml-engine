module AML
  def self.version
    "#{self.read_version}"
  end

  def self.read_version
    File.read self.version_path
  rescue
    raise 'Version file not found or unreadable.'
  end

  def self.version_path
    return '.engine_version' if File.exists? '.engine_version'
    AML::Engine.root + '.engine_version'
  end
end
