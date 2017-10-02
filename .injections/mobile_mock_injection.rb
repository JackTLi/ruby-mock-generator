require './.injections/injection.rb'

class MobileMockInjection < Injection
  def css
    '''<style>
      .mock-background {
        position: fixed;
        width: 1920px;
        height: 1080px;
        background-image: url("../../hand_mock.png");
        background-size: cover;
        background-repeat: no-repeat;
      }
      .mock-background img {
        position: fixed;
        left: 815px;
        top: 122px;
      }
     </style>'''
  end

  def html
    '''
    <div class="mock-background">
      <img src="../../' + @resource_path + '" />
    </div>
    '''
  end

  def get_injection
    css + html
  end
end
