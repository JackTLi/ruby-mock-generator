Dir["./.injections/*.rb"].each {|file| require file }

class InjectionManager
  class << self

    def set_config(config)
      @config = config
    end

    def get_injection(type, resource_path)
      Object.const_get(type).new(@config, resource_path).get_injection
    end
  end
end
