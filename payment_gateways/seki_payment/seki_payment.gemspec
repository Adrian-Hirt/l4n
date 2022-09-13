require_relative 'lib/seki_payment/version'

Gem::Specification.new do |spec|
  spec.name        = 'seki_payment'
  spec.version     = SekiPayment::VERSION
  spec.authors     = ['Adrian Hirt']
  spec.email       = ['aedu.hirt@gmail.com']
  spec.homepage    = 'https://l4n.ch'
  spec.summary     = 'SekiPayment for l4n.'
  spec.description = 'Payment adapter for l4n to register an order for later payment in the VSETH Sekretatiat.'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/Adrian-Hirt/l4n'
  spec.metadata['changelog_uri'] = 'https://github.com/Adrian-Hirt/l4n'

  spec.required_ruby_version = '>= 3.1'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end

  spec.add_dependency 'rails', '>= 7.0.1'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
