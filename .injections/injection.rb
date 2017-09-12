class Injection
  def initialize(config, resource_path)
    @config = config
    @resource_path = resource_path
  end

  def get_injection
    css_injection = css
    css_injection.gsub!("left", "right") if @config["orientation"] && @config["orientation"] == "right"
    css_injection + html
  end
end
