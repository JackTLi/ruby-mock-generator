require 'pry'
require 'yaml'
require 'benchmark'

file_name = ARGV[0]
global_config= YAML.load_file(file_name)
puts "=====CONFIG===="
puts global_config
puts "==============="

def create_mocks(config)
  @config = config

  url = @config["url"]
  dir_name = "Finished/" + url.gsub("http://", '').gsub("https://", '').split('/').first
  puts dir_name

  download_website(url) unless File.file?("#{dir_name}/index.html")

  #make svg
  svg = File.read('close.svg.template')
  svg.gsub!('{{$COLOR}}', @config["launcher_color"])
  open("#{dir_name}/close.svg", 'w') { |f|
    f.puts svg
  }

  page = get_webpage(dir_name)
  page.gsub!('cdn.sweettooth.io', '')

  make_launcher_mock(dir_name, page)
  make_referral_receiver_mock(dir_name, page) if @config["referral_receiver"]
  make_signup_mock(dir_name, page)
  make_welcome_card_mock(dir_name, page)
  make_referrals_mock(dir_name, page)
  make_vip_mock(dir_name, page)

  unless ARGV[2] == "debug"
    File.delete("#{dir_name}/index.html")
    File.delete("#{dir_name}/close.svg")
  end

end

def download_website(url)
  if @config["wordpress"]
    `wget -p --directory-prefix=Finished #{url}`
  else
    `wget -p -k --directory-prefix=Finished #{url}`
  end
end

def get_webpage(dir_name)
  File.read("#{dir_name}/index.html")
end

def get_launcher_injection
  css_block = '''<style>
    .mock-launcher {
      position: fixed;
      left: 25px;
      top: 1005px;
    }
    .mock-launcher img {
      height: 50px;
    }
   </style>'''
  html_block = '<div class="mock-launcher"> <img src="../../'+ @config["launcher"] +'" </div>'

  css_block + html_block
end

def get_open_launcher_injection
  css_block = '''<style>
  .mock-launcher {
    position: fixed;
    left: 25px;
    top: 1005px;
  }
  .mock-launcher img {
    height: 50px;
    width: 50px;
  }
  </style>'''

  html_block = '<div class="mock-launcher"> <img src="close.svg"> </div>'

  css_block + html_block
end

def get_referral_receiver_injection
  css_block = '''<style>
  .referral-receiver {
    position: fixed;
    left: 25px;
    top: 620px;
    z-index: 25;
  }
  .referral-receiver img {
    width: auto;
    height: 360px;
    z-index: 5;
    box-shadow: 1px 0 20px rgba(0,0,0,.1);
    border-radius: 5px;
  }
  </style>'''

  html_block = '<div class="referral-receiver"> <img src="../../'+ @config["referral_receiver"] +'" </div>'
  css_block + html_block
end

def get_signup_injection
  css_block = '''<style>
  .referral-receiver {
    position: fixed;
    left: 25px;
    top: 620px;
    z-index: 25;
  }
  .referral-receiver img {
    width: auto;
    height: 360px;
    z-index: 5;
    box-shadow: 1px 0 20px rgba(0,0,0,.1);
    border-radius: 5px;
  }
  </style>'''

  html_block = '<div class="referral-receiver"> <img src="../../'+ @config["signup"] +'" </div>'
  css_block + html_block
end

def get_welcome_card_injection
  css_block = '''<style>
  .referral-receiver {
    position: fixed;
    left: 25px;
    top: 340px;
    z-index: 25;
    width: 430px;
    height: 650px;
    background-image: url("../../' + @config["program_card"] + '");
    background-size: cover;
    background-repeat: no-repeat;
    box-shadow: 1px 0 20px rgba(0,0,0,.1);
    border-radius: 5px;
  }
  </style>'''

  html_block = '<div class="referral-receiver"></div>'
  css_block + html_block
end

def get_referral_injection
  css_block = '''<style>
  .referral-receiver {
    position: fixed;
    left: 25px;
    top: 340px;
    z-index: 25;
    width: 430px;
    height: 650px;
    background-image: url("../../' + @config["program_card"] + '");
    background-size: cover;
    background-repeat: no-repeat;
    background-position: 0px -670px;
    box-shadow: 1px 0 20px rgba(0,0,0,.1);
    border-radius: 5px;
  }
  </style>'''

  html_block = '<div class="referral-receiver"></div>'
  css_block + html_block
end

def get_vip_injection
  css_block = '''<style>
  .referral-receiver {
    position: fixed;
    left: 25px;
    top: 340px;
    z-index: 25;
    width: 430px;
    height: 650px;
    background-image: url("../../' + @config["program_card"] + '");
    background-size: cover;
    background-repeat: no-repeat;
    background-position: center bottom;
    box-shadow: 1px 0 20px rgba(0,0,0,.1);
    border-radius: 5px;
  }
  </style>'''

  html_block = '<div class="referral-receiver"></div>'
  css_block + html_block
end

def make_launcher_mock(dir_name, page)
  first_half, second_half = page.split("</body>")

  injection = get_launcher_injection

  final_result = first_half + injection + "</body>" + second_half
  file_name ="#{dir_name}/launcher_mock.html"
  open(file_name, 'w') { |f|
    f.puts final_result
  }

  puts "Benchmark for generating png for #{dir_name}/launcher_mock.png"
  Benchmark.bm do |x|
    x.report { `phantomjs screengrabber.js #{dir_name}/launcher_mock.html #{dir_name}/launcher_mock.png` } unless ARGV[1] == "skip"
  end
  puts "Done phantomjs for #{dir_name}/launcher_mock.png"

  unless ARGV[2] == "debug"
    File.delete("#{dir_name}/launcher_mock.html")
  end
end

def make_referral_receiver_mock(dir_name, page)
  first_half, second_half = page.split("</body>")

  injection = get_open_launcher_injection + get_referral_receiver_injection

  final_result = first_half + injection + "</body>" + second_half
  file_name ="#{dir_name}/referral_receiver_mock.html"
  open(file_name, 'w') { |f|
    f.puts final_result
  }

  puts "Benchmark for generating png for #{dir_name}/referral_receiver_mock.png"
  Benchmark.bm do |x|
    x.report { `phantomjs screengrabber.js #{dir_name}/referral_receiver_mock.html #{dir_name}/referral_receiver_mock.png` } unless ARGV[1] == "skip"
  end
  puts "Done phantomjs for #{dir_name}/referral_receiver_mock.png"

  unless ARGV[2] == "debug"
    File.delete("#{dir_name}/referral_receiver_mock.html")
  end
end

def make_signup_mock(dir_name, page)
  first_half, second_half = page.split("</body>")

  injection = get_open_launcher_injection + get_signup_injection

  final_result = first_half + injection + "</body>" + second_half
  file_name ="#{dir_name}/signup_mock.html"
  open(file_name, 'w') { |f|
    f.puts final_result
  }

  puts "Benchmark for generating png for #{dir_name}/signup_mock.png"
  Benchmark.bm do |x|
    x.report { `phantomjs screengrabber.js #{dir_name}/signup_mock.html #{dir_name}/signup_mock.png` } unless ARGV[1] == "skip"
  end
  puts "Done phantomjs for #{dir_name}/signup_mock.png"

  unless ARGV[2] == "debug"
    File.delete("#{dir_name}/signup_mock.html")
  end
end

def make_welcome_card_mock(dir_name, page)
  first_half, second_half = page.split("</body>")

  injection = get_open_launcher_injection + get_welcome_card_injection

  final_result = first_half + injection + "</body>" + second_half
  file_name ="#{dir_name}/welcome_card_and_points_mock.html"
  open(file_name, 'w') { |f|
    f.puts final_result
  }

  puts "Benchmark for generating png for #{dir_name}/welcome_card_and_points_mock.png"
  Benchmark.bm do |x|
    x.report { `phantomjs screengrabber.js #{dir_name}/welcome_card_and_points_mock.html #{dir_name}/welcome_card_and_points_mock.png` } unless ARGV[1] == "skip"
  end
  puts "Done phantomjs for #{dir_name}/welcome_card_and_points_mock.png"

  unless ARGV[2] == "debug"
    File.delete("#{dir_name}/welcome_card_and_points_mock.html")
  end
end

def make_referrals_mock(dir_name, page)
  first_half, second_half = page.split("</body>")

  injection = get_open_launcher_injection + get_referral_injection

  final_result = first_half + injection + "</body>" + second_half
  file_name ="#{dir_name}/referral_mock.html"
  open(file_name, 'w') { |f|
    f.puts final_result
  }

  puts "Benchmark for generating png for #{dir_name}/referral_mock.png"
  Benchmark.bm do |x|
    x.report { `phantomjs screengrabber.js #{dir_name}/referral_mock.html #{dir_name}/referral_mock.png` } unless ARGV[1] == "skip"
  end
  puts "Done phantomjs for #{dir_name}/referral_mock.png"

  unless ARGV[2] == "debug"
    File.delete("#{dir_name}/referral_mock.html")
  end
end

def make_vip_mock(dir_name, page)
  first_half, second_half = page.split("</body>")

  injection = get_open_launcher_injection + get_vip_injection

  final_result = first_half + injection + "</body>" + second_half
  file_name ="#{dir_name}/vip_mock.html"
  open(file_name, 'w') { |f|
    f.puts final_result
  }

  puts "Benchmark for generating png for #{dir_name}/vip_mock.png"
  Benchmark.bm do |x|
    x.report { `phantomjs screengrabber.js #{dir_name}/vip_mock.html #{dir_name}/vip_mock.png` } unless ARGV[1] == "skip"
  end
  puts "Done phantomjs for #{dir_name}/vip_mock.png"

  unless ARGV[2] == "debug"
    File.delete("#{dir_name}/vip_mock.html")
  end
end

global_config["sites"].each do |site|
  create_mocks(site)
end
