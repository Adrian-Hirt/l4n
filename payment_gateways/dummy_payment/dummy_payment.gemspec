require_relative 'lib/dummy_payment/version'

Gem::Specification.new do |spec|
  spec.name        = 'dummy_payment'
  spec.version     = DummyPayment::VERSION
  spec.authors     = ['Adrian Hirt']
  spec.email       = ['aedu.hirt@gmail.com']
  spec.homepage    = 'https://l4n.ch'
  spec.summary     = 'DummyPayment for l4n.'
  spec.description = 'DummyPayment adapter for l4n.'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/Adrian-Hirt/l4n'
  spec.metadata['changelog_uri'] = 'https://github.com/Adrian-Hirt/l4n'

  spec.required_ruby_version = '>= 3.0'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end

  spec.add_dependency 'rails', '>= 7.0.1'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
