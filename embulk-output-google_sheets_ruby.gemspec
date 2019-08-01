
Gem::Specification.new do |spec|
  spec.name          = 'embulk-output-google_sheets_ruby'
  spec.version       = '0.1.1'
  spec.authors       = ['ariarijp']
  spec.summary       = 'Google Sheets Ruby output plugin for Embulk'
  spec.description   = 'Dumps records to Google Sheets.'
  spec.email         = ['takuya.arita@gmail.com']
  spec.licenses      = ['MIT']
  spec.homepage      = 'https://github.com/ariarijp/embulk-output-google_sheets_ruby'

  spec.files         = `git ls-files`.split("\n") + Dir['classpath/*.jar']
  spec.test_files    = spec.files.grep(%r{^(test|spec)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'google-api-client', '~> 0.8'

  spec.add_development_dependency 'bundler', ['>= 1.10.6']
  spec.add_development_dependency 'embulk', ['>= 0.8.39']
  spec.add_development_dependency 'rake', ['>= 10.0']
end
