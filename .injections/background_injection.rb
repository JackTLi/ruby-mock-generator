require './.injections/injection.rb'

class BackgroundInjection < Injection
  def css
    '''<style>
      .mock-bg {
        position: fixed;
        left: 0px;
        top: 0px;
        z-index: 9998;
      }
      .mock-bg img {
        height: 1080px !important;
        width: 1920px !important;
      }
     </style>'''
  end

  def html
    '<div class="mock-bg"> <img src="../../'+ @resource_path +'"/> </div>'
  end
end
