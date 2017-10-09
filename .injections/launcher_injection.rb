require './.injections/injection.rb'

class LauncherInjection < Injection
  def css
    '''<style>
      .mock-launcher {
        position: fixed;
        left: 25px;
        top: 1005px;
        z-index: 9999;
      }
      .mock-launcher .launcher {
        height: 50px !important;
      }
      .mock-launcher .launcher-close {
        height: 30px !important;
        margin: 10px !important;
      }
     </style>'''
  end

  def html
    '<div class="mock-launcher"> <img src="../../'+ @resource_path +'"/> </div>'
  end

  def mobile_html_left
    '<div class="mock-launcher"> <img class="launcher" src="../../'+ @resource_path +'"/> <img class="launcher-close" src="launcher-close.svg"/> </div>'
  end

  def mobile_html_right
    '<div class="mock-launcher"> <img class="launcher-close" src="launcher-close.svg"/> <img class="launcher" src="../../'+ @resource_path +'"/> </div>'
  end

  def get_mobile_injection
    css_injection = mobile_css
    mobile_html = mobile_html_left

    if @config["orientation"] && @config["orientation"] == "right"
      css_injection.gsub!("left", "right")
      mobile_html = mobile_html_right
    end

    css_injection + mobile_html
  end
end
