module Localtunnel
  class Client
    @@pid = nil

    def self.start(options = {})
      raise ClientAlreadyStartedError if running?

      raise NpmPackageNotFoundError unless package_installed?

      execution_string = "lt"
      execution_string << " -p '#{options[:port]}'" if options.key?(:port)
      execution_string << " -s '#{options[:subdomain]}'" if options.key?(:subdomain)
      execution_string << " -h '#{options[:remote_host]}'" if options.key?(:remote_host)
      execution_string << " -l '#{options[:local_host]}'" if options.key?(:local_host)

      @@pid = Process.spawn(execution_string)
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
end
