$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "lianjifen_client/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name = "lianjifen_client"
  spec.version = LianjifenClient::VERSION
  spec.authors = ["hzh"]
  spec.email = ["sforce1000@gmail.com"]
  spec.homepage = "http://mygemserver.com"
  spec.summary = "Summary of LianjifenClient."
  spec.description = "Description of LianjifenClient."
  spec.license = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
          "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  # spec.add_dependency "rails", "~> 5.2.0"

  # spec.add_development_dependency "sqlite3"
end
