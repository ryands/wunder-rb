require 'wunder'
require 'thor'
require 'yaml'

module Wunder
  class CLI < Thor
    class_option :config, default: nil, desc: 'Config file to use for wunder'

    desc 'conditions LOCATION', "Current conditions, in your terminal."
    def conditions(location = config['default_location'])
      w = Wunder::Wunderground.new(api_token: config['api_token'])
      c = w.conditions(location).current_observation
      puts <<-HEREDOC
Weather for #{c.display_location.full} @ #{c.local_time_rfc822}:
Temperature: #{c.temperature_string}, Humidity: #{c.relative_humidity}
Precipitation: #{c.precip_today_string}
Forecast url: #{c.forecast_url}

      HEREDOC
    end

    desc 'generate_config <api_token> [default_location]', 'Generate a config file for wunder'
    option :dest, aliases: %w(f), default: File.join(ENV['PWD'], 'wunder.conf'), desc: 'Config destination'
    option :home, default: false, type: :boolean, desc: 'Write config to ~/.wunderrc'
    def generate_config(api_token, default_location = nil)
      if options[:home]
        file = "#{ENV['HOME']}/.wunderrc"
      else
        file = options[:dest]
      end

      File.open(file, 'w') do |f|
        f.puts "api_token: #{api_token}"
        f.puts "default_location: #{default_location}" unless default_location.nil?
      end
      puts "Wrote config to #{file}"
    end

    private

    def config
      [options[:config], "#{ENV['HOME']}/.wunderrc", "#{ENV['PWD']}/wunder.conf"].each do |f|
        return YAML.load(File.open(f, 'r')) if !f.nil? and File.exist?(f)
      end
      raise 'Could not find wunder config in ~/.wunderrc or ./wunder.conf'
    end

  end
end
