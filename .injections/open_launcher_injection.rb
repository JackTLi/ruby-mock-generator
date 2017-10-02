require './.injections/injection.rb'

class OpenLauncherInjection < Injection
  def css
    '''<style>
    .mock-launcher {
      position: fixed;
      left: 25px;
      top: 1005px;
      z-index: 9999;
    }
    .mock-launcher img {
      height: 50px !important;
      width: 50px !important;
    }
    </style>'''
  end

  def mobile_css
    '''<style></style>'''
  end

  def html
    '<div class="mock-launcher"> <img src="close.svg"> </div>'
  end
end
