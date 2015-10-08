module Localtunnel
  class Client
    @@pid = nil

    def self.start
      ensure_package

      @@pid = Process.spawn("lt --port 3000") unless running?
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
