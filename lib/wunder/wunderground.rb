require 'wunder'
require 'httparty'
require 'multi_json'
require 'hashie'

# Class to deal with the wunderground API

module Wunder
  class Wunderground
    include HTTParty

    def initialize (options = {})
      @api_token = options[:api_token]
      raise 'API Token required for Wunder::Wunderground' unless @api_token
    end

    def conditions (location)
      response = self.class.get("http://api.wunderground.com/api/#{@api_token}/conditions/q/#{location}.json")
      Hashie::Mash.new(MultiJson.load(response.body))
    end

  end
end
