lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rokku/version"

Gem::Specification.new do |spec|
  spec.name          = "rokku"
  spec.version       = Rokku::VERSION
  spec.authors       = ["Sebastjan Hribar"]
  spec.email         = ["sebastjan.hribar@gmail.com"]

  spec.summary       = %q{Rokku is a small authorization library for Hanami projects.}
  spec.homepage      = "https://github.com/sebastjan-hribar/rokku"
  spec.license       = "MIT"


  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
