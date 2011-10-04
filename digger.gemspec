$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "lib/digger/version"

Gem::Specification.new do |s|
  s.name        = 'digger'
  s.author      = 'Slava Kravchenko'
  s.email	= 'slava.kravchenko@gmail.com'
  s.version     = ("$Release: #{Digger::VERSION} $" =~ /[\.\d]+/) && $&
  s.platform    = Gem::Platform::RUBY
  s.homepage    = "https://github.com/cordawyn/digger"
  s.requirements = 'DIG reasoner'
  s.summary     = "Ruby DIG engine."
  s.description = <<-END
    Digger allows to query DIG reasoners via HTTP.
  END

  files = Dir.glob('lib/**/*')
  files.concat Dir.glob('data/**/*')
  files.concat %w[Rakefile Gemfile digger.gemspec README.md]

  s.files       = files
  s.test_files  = Dir.glob('spec/**/*')

  s.add_dependency "nokogiri", "~> 1.5"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", "~> 2"
end
