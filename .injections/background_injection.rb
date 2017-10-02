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

  def mobile_css
    '''<style>
      .mock-bg {
        position: fixed;
        left: 0px;
        top: 0px;
        z-index: 9998;
        background-color: white;
      }
      .mock-bg img {
        height: 667px !important;
        width: 375px !important;
        box-shadow: 0px 0px 20px 1px rgba(0, 0, 0, 0.22);
      }
     </style>'''
  end

  def html
    '<div class="mock-bg"> <img src="../../'+ @resource_path +'"/> </div>'
  end

  def mobile_html
    '''
    <head><meta name="viewport" content="width=device-width,initial-scale=1"></head>
    <div class="mock-bg"> <img src="../../'+ @resource_path +'"/> </div>
    '''
  end
end
