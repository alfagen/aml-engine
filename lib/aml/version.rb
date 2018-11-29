module AML
  AML::VERSION = version

  def version
    File.read('.semver').split("\n")[1..3].map{ |x| x.split(' ')[1] }.join('.')
  rescue
    raise 'File .semver not exists or not valid.'
  end
end
