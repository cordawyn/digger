require 'rubygems'
require 'spec/rake/spectask'
require 'rake/gempackagetask'
require 'lib/digger/version'

Spec::Rake::SpecTask.new do |t|
  t.warning = false
  t.rcov = true
end

spec = Gem::Specification.new do |s|
  s.name        = 'digger'
  s.author      = 'Slava Kravchenko'
  s.email	= 'slava.kravchenko@gmail.com'
  s.version     = ("$Release: #{Digger::VERSION} $" =~ /[\.\d]+/) && $&
  s.platform    = Gem::Platform::RUBY
  s.homepage    = "http://cordawyn.dnsdojo.net/ruby"
  s.requirements = 'DIG reasoner'
  s.summary     = "Ruby DIG engine."
  # TODO: add dependencies
  s.description = <<-END
    Digger allows to query DIG reasoners via HTTP.
  END

  ## files
  files = Dir.glob('lib/**/*')
  files += Dir.glob('data/**/*')
  files += %w[Rakefile]
  s.files       = files
  s.test_files  = Dir.glob('spec/**/*')

  # s.extra_rdoc_files = ['README', 'ChangeLog']
  s.has_rdoc = true
end

Rake::GemPackageTask.new(spec) do |pkg|
  # pkg.need_tar = true
end
