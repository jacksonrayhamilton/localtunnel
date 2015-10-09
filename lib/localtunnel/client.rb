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
    end

    def self.stop
      Process.kill("KILL", @@pid) if running?
    end

    def self.running?
      !@@pid.nil? && Process.waitpid(@@pid, Process::WNOHANG).nil?
    rescue Errno::ECHILD
      false
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
      s = "lt"
      s << " -p '#{options[:port]}'" if options.key?(:port)
      s << " -s '#{options[:subdomain]}'" if options.key?(:subdomain)
      s << " -h '#{options[:remote_host]}'" if options.key?(:remote_host)
      s << " -l '#{options[:local_host]}'" if options.key?(:local_host)
      s << " 1>#{log.path} 2>&1"
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
