require './.injections/injection.rb'

class OpenLauncherInjection < Injection
  def css
    '''<style>
    .referral-receiver {
      position: fixed;
      left: 25px;
      top: 620px;
      z-index: 9999;
    }
    .referral-receiver img {
      width: auto !important;
      height: 360px !important;
      z-index: 5;
      box-shadow: 1px 0 20px rgba(0,0,0,.1);
      border-radius: 5px;
    }
    </style>'''
  end

  def html
    '<div class="referral-receiver"> <img src="../../'+ @resource_path +'"/> </div>'
  end
end
