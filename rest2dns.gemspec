# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rest2dns/version'

Gem::Specification.new do |spec|
  spec.name          = 'rest2dns'
  spec.version       = Rest2dns::VERSION
  spec.authors       = ['Jiri Kubicek']
  spec.email         = ['jiri.kubicek@kraxnet.cz']

  spec.summary       = 'DNS remote configuration server with simple REST API.'
  spec.description   = 'With Rest2DNS you can simply add, update or delete zone from your DNS server remotely via HTTP protocol.'
  spec.homepage      = "https://github.com/kraxnet/rest2dns"
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = "https://github.com/kraxnet/rest2dns"
    # spec.metadata['changelog_uri'] = "TODO: Put your gem's CHANGELOG.md URL here."
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.11'
  spec.add_development_dependency 'rack-test', '~> 1.1'

  spec.add_runtime_dependency 'json', '~> 2.2'
  spec.add_runtime_dependency 'puma', '~> 3.12'
  spec.add_runtime_dependency 'sinatra', '~> 2.0'
end
