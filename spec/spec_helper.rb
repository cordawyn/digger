require 'logger'
require 'lib/digger'

Digger.logger = Logger.new('test.log')

RSpec.configure do |config|
  config.include(Digger)
end
