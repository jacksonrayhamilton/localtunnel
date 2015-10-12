require "tempfile"

module Localtunnel
  class Client
    @@pid = nil
    @@url = nil

    def self.start(options = {})
      return if running?

      raise NpmPackageNotFoundError unless package_installed?

      log = Tempfile.new("localtunnel")
      @@pid = Process.spawn(execution_string(log, options))
      @@url = parse_url!(log)

      at_exit { stop } # Ensure process is killed if Ruby exits.

      return # Explicitly return nil.
    end

    def self.stop
      return unless running?

      `kill -9 #{@@pid}` # Can't use Process.kill, since JRuby on Raspbian doesn't support it.
      @@pid = nil

      return # Explicitly return nil.
    end

    def self.running?
      !@@pid.nil?
    end

    def self.url
      @@url if running?
    end

    def self.package_installed?
      !`lt --version`.to_s.empty?
    rescue Errno::ENOENT
      false
    end

    def self.execution_string(log, options)
      s = "exec lt"
      s << " -p '#{options[:port]}'" if options.key?(:port)
      s << " -s '#{options[:subdomain]}'" if options.key?(:subdomain)
      s << " -h '#{options[:remote_host]}'" if options.key?(:remote_host)
      s << " -l '#{options[:local_host]}'" if options.key?(:local_host)
      s << " > #{log.path}"
    end

    def self.parse_url!(log, max_seconds = 10)
      max_seconds.times do
        sleep 1
        raise ClientConnectionFailedError unless running?

        log.rewind
        if match_data = log.read.match(/^your url is: (.*)$/)
          return match_data.captures[0]
        end
      end

      stop
      raise ClientConnectionFailedError
    end
  end

  class NpmPackageNotFoundError < StandardError
  end

  class ClientConnectionFailedError < StandardError
  end
end
