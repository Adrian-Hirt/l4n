require_relative 'lib/paypal_payment/version'

Gem::Specification.new do |spec|
  spec.name        = 'paypal_payment'
  spec.version     = PaypalPayment::VERSION
  spec.authors     = ['Adrian Hirt']
  spec.email       = ['aedu.hirt@gmail.com']
  spec.homepage    = 'https://l4n.ch'
  spec.summary     = 'PaypalPayment for l4n.'
  spec.description = 'Payment adapter for l4n to pay via the Paypal Checkout API'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/Adrian-Hirt/l4n'
  spec.metadata['changelog_uri'] = 'https://github.com/Adrian-Hirt/l4n'

  spec.required_ruby_version = '>= 3.3'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end

  spec.add_dependency 'httparty'
  spec.add_dependency 'rails', '>= 7.1.2'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
