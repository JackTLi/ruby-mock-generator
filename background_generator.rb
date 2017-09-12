require 'pry'
require 'yaml'
require 'benchmark'
require './.injections/injection_manager.rb'

file_name = ARGV[0]
global_config= YAML.load_file(file_name)
puts "=====CONFIG===="
puts global_config
puts "==============="

def create_mocks(config)
  @config = config
  InjectionManager.set_config(@config)

  url = @config["url"]
  @dir_name = "Finished/" + url.gsub("http://", '').gsub("https://", '').split('/').first

  background_path = "#{@config["asset_path"]}/Background.png"
  if File.file?(background_path)
    background_element = InjectionManager.get_injection(:BackgroundInjection, background_path)
    page = "<body> #{background_element} </body>"
  else
    download_website(url) unless File.file?("#{@dir_name}/index.html")
    page = get_webpage
    page.gsub!('cdn.sweettooth.io', '') # don't inject any sweettooth js that renders the old launcher
  end
  make_svg

  mocks = {
    "launcher_mock" => {
      resource: "Launcher.png",
      injections: [:LauncherInjection]
    },
    "referral_receiver" => {
      resource: "Referral Receiver.png",
      injections: [:OpenLauncherInjection, :ReferralReceiverInjection]
    },
    "signup" => {
      resource: "Signup.png",
      injections: [:OpenLauncherInjection, :SignupInjection]
    },
    "welcome_card" => {
      resource: "Program Card.png",
      injections: [:OpenLauncherInjection, :WelcomeCardInjection]
    },
    "referral" => {
      resource: "Program Card.png",
      injections: [:OpenLauncherInjection, :ReferralInjection]
    },
    "vip" => {
      resource: "Program Card.png",
      injections: [:OpenLauncherInjection, :VipInjection]
    }
  }

  mocks.each do |file_name, details|
    html_path   = "#{@dir_name}/#{file_name}.html"
    png_path    = "#{@dir_name}/#{file_name}.png"

    if mock_code = make_mock(page, details)
      write_mock_code_to_file(html_path, mock_code)
      phantomjs_screenshot(html_path, png_path)
    end
  end

  unless ARGV[2] == "debug"
    File.delete("#{@dir_name}/index.html") if File.file?("#{@dir_name}/index.html")
    File.delete("#{@dir_name}/close.svg") if File.file?("#{@dir_name}/close.svg")
    File.delete("#{@dir_name}/robots.txt")if File.file?("#{@dir_name}/robots.txt")
  end
end

def download_website(url)
  `wget -p -k --directory-prefix=Finished #{url}`
end

def get_webpage
  File.read("#{@dir_name}/index.html")
end

def make_svg
  svg = File.read('close.svg.template')
  svg.gsub!('{{$COLOR}}', @config["launcher_color"])
  open("#{@dir_name}/close.svg", 'w') { |f|
    f.puts svg
  }
end

def make_mock(page, details)
  return unless @config["asset_path"]
  return unless File.file?("#{@config["asset_path"]}/#{details[:resource]}")

  first_half, second_half = page.split("</body>")
  resource_path = "#{@config["asset_path"]}/#{details[:resource]}"

  injection_code = ""
  details[:injections].each do |injection|
    injection_code += InjectionManager.get_injection(injection, resource_path)
  end
  first_half + injection_code + "</body> #{second_half}"
end

def write_mock_code_to_file(full_path, code)
  open(full_path, 'w') { |f|
    f.puts code
  }
end

def phantomjs_screenshot(html_path, png_path)
  puts "Benchmark: #{png_path}"
  Benchmark.bm do |x|
    x.report { `phantomjs screengrabber.js #{html_path} #{png_path}` } unless ARGV[1] == "skip"
  end
  puts "Done phantomjs for #{png_path}"
end

global_config["sites"].each do |site|
  create_mocks(site)
end
