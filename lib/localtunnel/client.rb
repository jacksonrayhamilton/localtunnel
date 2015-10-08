module Localtunnel
  class Client
    def self.ensure_package
      `lt --version`
    rescue Errno::ENOENT
      raise PackageNotFoundError, "localtunnel npm package not found"
    end
  end

  class PackageNotFoundError < StandardError
  end
end
