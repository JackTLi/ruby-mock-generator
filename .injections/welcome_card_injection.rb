require './.injections/injection.rb'

class WelcomeCardInjection < Injection
  def css
    '''<style>
    .referral-receiver {
      position: fixed;
      left: 25px;
      top: 340px;
      z-index: 9999;
      width: 430px !important;
      height: 650px !important;
      background-image: url("../../' + @resource_path + '");
      background-size: cover;
      background-repeat: no-repeat;
      box-shadow: 1px 0 20px rgba(0,0,0,.1);
      border-radius: 5px;
    }
    </style>'''
  end

  def mobile_css
    '''<style>
    .referral-receiver {
      position: fixed;
      left: 0px;
      top: 0px;
      z-index: 9999;
      width: 375px !important;
      height: 667px !important;
      background-image: url("../../' + @resource_path + '");
      background-size: cover;
      background-repeat: no-repeat;
      box-shadow: 1px 0 20px rgba(0,0,0,.1);
    }
    .referral-receiver img {
      position: absolute;
      top: 20px;
      right: 20px;
      height: 17px;
      width: 17px;
    }
    </style>'''
  end

  def html
    '<div class="referral-receiver"></div>'
  end

  def mobile_html
    '<div class="referral-receiver"><img src="close_mobile.svg"/></div>'
  end
end
