module AML
  def self.version
    File.read('.semver').split("\n")[1..3].map{ |x| x.split(' ')[1] }.join('.')
  rescue
    raise 'Error while reading .semver file.'
  end

  VERSION = version
end
