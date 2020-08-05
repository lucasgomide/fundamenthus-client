require 'fundamenthus/version'
require 'fundamenthus/source'

module Fundamenthus
  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  class Error < StandardError; end
  # Your code goes here...
end
