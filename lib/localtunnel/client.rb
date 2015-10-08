module Localtunnel
  class Client
    @@pid = nil

    def self.start(options = {})
      ensure_package

      execution_string = "lt"
      execution_string << " -p '#{options[:port]}'" if options.key?(:port)
      execution_string << " -s '#{options[:subdomain]}'" if options.key?(:subdomain)
      execution_string << " -h '#{options[:remote_host]}'" if options.key?(:remote_host)
      execution_string << " -l '#{options[:local_host]}'" if options.key?(:local_host)

      @@pid = Process.spawn(execution_string) unless running?
    end

    def self.stop
      Process.kill("KILL", @@pid) if running?
    end

    def self.running?
      !@@pid.nil? && Process.waitpid(@@pid, Process::WNOHANG).nil?
    rescue Errno::ECHILD
      false
    end

    def self.ensure_package
      `lt --version`
    rescue Errno::ENOENT
      raise PackageNotFoundError, "localtunnel npm package not found"
    end
  end

  class PackageNotFoundError < StandardError
  end
end
