$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Digger

  HTTP_HEADER = {
    'Content-Type' => 'text/xml'
  }.freeze

  SPECIAL_ROLES = [
    "_BOTTOM_DATA_PROPERTY_",
    "_TOP_DATA_PROPERTY_",
    "_TOP_OBJECT_PROPERTY_",
    "_BOTTOM_OBJECT_PROPERTY_"
  ].freeze

  SPECIAL_CLASSES = [
    "<top/>",
    "<bottom/>"
  ].freeze

  # DIG namespace declaration.
  NS = "http://dl.kr.org/dig/2003/02/lang".freeze

  class << self
    attr_accessor :logger
  end

  require "digger/reasoner"
  require "digger/query"
  require 'digger/version'

end
