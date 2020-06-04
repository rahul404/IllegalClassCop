require_relative 'lib/illegal_class_cop/version'

Gem::Specification.new do |spec|
  spec.name          = "illegal_class_cop"
  spec.version       = IllegalClassCop::VERSION
  spec.authors       = ["Rahul Ahuja"]

  spec.summary       = %q{Finds all illegally accessed class, module and constants in engines.}
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency 'parser', '~> 2.5', '>= 2.5.0.3'
end
