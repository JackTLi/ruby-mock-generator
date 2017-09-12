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

  def html
    '<div class="referral-receiver"></div>'
  end
end
