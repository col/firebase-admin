require File.expand_path('lib/firebase-admin/version', __dir__)

Gem::Specification.new do |s|
  s.add_development_dependency('rake', '~> 13.0')
  s.add_development_dependency('rspec', '~> 3.10')
  s.add_development_dependency('rubocop', '~> 1.9')
  s.add_development_dependency('webmock', '~> 3.11')
  s.add_runtime_dependency('addressable', '~> 2.7')
  s.add_runtime_dependency('faraday', '~> 2.4', '>= 2.0')
  s.add_runtime_dependency('faraday-mashify', '~> 0.1.0')
  s.add_runtime_dependency('hashie',  '~> 4.1')
  s.add_runtime_dependency('jwt', '>= 2.2')
  s.add_runtime_dependency('multi_json', '~> 1.15')
  s.authors = ['Colin Harris']
  s.description = 'A Ruby wrapper for the Firebase Admin APIs'
  s.email = ['colin@jiva.ag']
  s.files = `git ls-files`.split("\n")
  s.homepage = 'https://github.com/col/firebase-admin'
  s.license = 'MIT'
  s.name = 'firebase-admin'
  s.platform = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.required_ruby_version = '> 2.7'
  s.summary = 'Ruby wrapper for the Firebase Admin APIs'
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.version = FirebaseAdmin::VERSION.dup
  s.metadata = {
    'rubygems_mfa_required' => 'true'
  }
end
