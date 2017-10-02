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
      .mock-launcher img {
        height: 50px !important;
      }
     </style>'''
  end

  def mobile_css
    css.gsub('1005px', '595px')
  end

  def html
    '<div class="mock-launcher"> <img src="../../'+ @resource_path +'"/> </div>'
  end
end
