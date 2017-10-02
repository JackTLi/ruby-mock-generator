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

  def get_mobile_injection
    css_injection = mobile_css
    css_injection.gsub!("left", "right") if @config["orientation"] && @config["orientation"] == "right"
    css_injection + mobile_html
  end

  def css
    '<script></script>'
  end

  def mobile_css
    '<script></script>'
  end

  def html
    '<div></div>'
  end

  def mobile_html
    html
  end
end
