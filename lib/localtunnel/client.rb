require "tempfile"

module Localtunnel
  class Client
    @@pid = nil
    @@url = nil

    def self.start(options = {})
      raise ClientAlreadyStartedError if running?
      raise NpmPackageNotFoundError unless package_installed?

      # Spawn the localtunnel process.
      log = Tempfile.new("localtunnel")
      execution_string = "lt"
      execution_string << " -p '#{options[:port]}'" if options.key?(:port)
      execution_string << " -s '#{options[:subdomain]}'" if options.key?(:subdomain)
      execution_string << " -h '#{options[:remote_host]}'" if options.key?(:remote_host)
      execution_string << " -l '#{options[:local_host]}'" if options.key?(:local_host)
      execution_string << " 1>#{log.path} 2>&1"
      @@pid = Process.spawn(execution_string)

      # Get the localtunnel URL.
      10.times do
        raise ClientConnectionFailedError unless running?

        log.rewind
        if match_data = log.read.match(/^your url is: (.*)$/)
          @@url = !match_data.nil? && match_data.captures[0]
          break
        end

        sleep 1
      end

      raise ClientConnectionFailedError unless @@url
    end

    def self.stop
      raise ClientAlreadyStoppedError unless running?

      Process.kill("KILL", @@pid)
    end

    def self.running?
      !@@pid.nil? && Process.waitpid(@@pid, Process::WNOHANG).nil?
    rescue Errno::ECHILD
      false
    end

    def self.url
      raise ClientAlreadyStoppedError unless running?

      @@url
    end

    def self.package_installed?
      !`lt --version`.to_s.empty?
    rescue Errno::ENOENT
      false
    end
  end

  class NpmPackageNotFoundError < StandardError
  end

  class ClientAlreadyStartedError < StandardError
  end

  class ClientAlreadyStoppedError < StandardError
  end

  class ClientConnectionFailedError < StandardError
  end
end
