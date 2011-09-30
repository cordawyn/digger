require 'rubygems'
require 'spec/autorun'

require 'logger'
require 'lib/digger'

Digger.logger = Logger.new('test.log')

Spec::Runner.configure do |config|
  config.include(Digger)
end
