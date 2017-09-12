class Injection
  def initialize(config, resource_path)
    @config = config
    @resource_path = resource_path
  end

  def get_injection
    css.gsub!("left", "right") if @config["orientation"] && @config["orientation"] == "right"
    css + html
  end
end
