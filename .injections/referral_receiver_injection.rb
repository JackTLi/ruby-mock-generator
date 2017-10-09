require './.injections/injection.rb'

class ReferralReceiverInjection < Injection
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

  def mobile_css
    '''<style>
    .referral-receiver {
      position: fixed;
      left: 0px;
      top: 355px;
      z-index: 9999;
    }
    .referral-receiver .content {
      width: 375px !important;
      height: 312px !important;
      z-index: 5;
      box-shadow: 1px 0 20px rgba(0,0,0,.1);
    }
    .referral-receiver .close {
      position: absolute;
      top: 20px;
      right: 20px;
      height: 17px;
      width: 17px;
      z-index: 6;
    }
    </style>'''
  end

  def html
    '<div class="referral-receiver"> <img class="content" src="../../'+ @resource_path +'"/> </div>'
  end

  def mobile_html
    '<div class="referral-receiver"> <img class="content" src="../../'+ @resource_path +'"/> <img class="close" src="close_mobile.svg"/> </div>'
  end
end
