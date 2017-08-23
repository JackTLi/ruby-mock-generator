require 'pry'
require 'yaml'
require 'screencap'

file_name = ARGV[0]
@config= YAML.load_file(file_name)
puts "=====CONFIG===="
puts @config
puts "==============="

def main
  url = @config["url"]
  dir_name = url.gsub("http://", '').gsub("https://", '').split('/').first
  puts dir_name

  download_website(url) unless File.file?("#{dir_name}/index.html")
  page = get_webpage(dir_name)

  first_half, second_half = page.split("</body>")

  # launcher mock
  injection = get_launcher_injection
  final_result = first_half + injection + "</body>" + second_half
  open("#{dir_name}/launcher_mock.html", 'w') { |f|
    f.puts final_result
  }

  # # referral receiver mock
  # injection = get_launcher_injection + get_referral_receiver_injection
  # final_result = first_half + injection + "</body>" + second_half
  # open("#{dir_name}/referral_receiver_mock.html", 'w') { |f|
  #   f.puts final_result
  # }
end

def download_website(url)
  `wget -p -k #{url}`
end

def get_webpage(dir_name)
  File.read("#{dir_name}/index.html")
end

def get_launcher_injection
  css_block = '''<style>
    .mock-launcher {
      position: fixed;
      bottom: 25px;
      left: 25px;
    }
    .mock-launcher img {
      height: 50px;
    }
   </style>'''
  html_block = '<div class="mock-launcher"> <img src="../'+ @config["launcher"] +'" </div>'

  css_block + html_block
end

main



