require_relative 'lib/fundamenthus/version'

Gem::Specification.new do |spec|
  spec.name          = 'fundamenthus-client'
  spec.version       = Fundamenthus::VERSION
  spec.authors       = ['lucasgomide']
  spec.email         = ['lucaslg200@gmail.com']

  spec.summary       = 'Export brazilian stock data from the best ones stock analysis websites'
  spec.description   = "Keep updated about the stocks' fundamentals is essential. This gem export
  brazilian stock data from the best ones stock analysis websites in JSON format"
  spec.license = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'curb', '~> 0.9'
  spec.add_dependency 'nokogiri', '~> 1.6'

  spec.add_development_dependency 'pry', '~> 0.13'
  spec.add_development_dependency 'rubocop', '<1'
  spec.add_development_dependency 'rspec', '<4'
  spec.add_development_dependency 'webmock', '<4'
  spec.add_development_dependency 'vcr', '<7'
end
