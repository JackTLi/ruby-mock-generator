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
  mobile_background_path = "#{@config["asset_path"]}/Background_mobile.png"
  if File.file?(background_path) || File.file?(mobile_background_path)
    raise StandardError, "Background.png not found" unless File.exist?(background_path)
    raise StandardError, "Background_mobile.png not found" unless File.exist?(mobile_background_path)

    FileUtils.mkdir_p(@dir_name) unless File.exist?(@dir_name)
    background_element = InjectionManager.get_injection(:BackgroundInjection, background_path)
    page = "<body> #{background_element} </body>"

    mobile_background_element = InjectionManager.get_mobile_injection(:BackgroundInjection, mobile_background_path)
    mobile_page = "<body> #{mobile_background_element} </body>"
  else
    download_website(url) unless File.file?("#{@dir_name}/index.html")
    page = get_webpage
    page.gsub!('cdn.sweettooth.io', '') # don't inject any sweettooth js that renders the old launcher

    mobile_page = page
  end
  make_svg

  mocks = {
    # "launcher_mock" => {
    #   resource: "Launcher.png",
    #   injections: [:LauncherInjection]
    # },
    # "referral_receiver" => {
    #   resource: "Referral Receiver.png",
    #   injections: [:OpenLauncherInjection, :ReferralReceiverInjection]
    # },
    # "signup" => {
    #   resource: "Signup.png",
    #   injections: [:OpenLauncherInjection, :SignupInjection]
    # },
    # "welcome_card" => {
    #   resource: "Program Cards.png",
    #   injections: [:OpenLauncherInjection, :WelcomeCardInjection]
    # },
    "referral" => {
      resource: "Program Cards.png",
      injections: [:OpenLauncherInjection, :ReferralInjection]
    },
    # "vip" => {
    #   resource: "Program Cards.png",
    #   injections: [:OpenLauncherInjection, :VipInjection]
    # }
  }

  mocks.each do |file_name, details|
    desktop_html_path = "#{@dir_name}/#{file_name}.html"
    mobile_html_path  = "#{@dir_name}/#{file_name}_mobile_temp.html"
    desktop_png_path  = "#{@dir_name}/#{file_name}.png"
    mobile_png_path   = "#{@dir_name}/#{file_name}_mobile_temp.png"

    generate_mock(page, details, desktop_html_path, desktop_png_path, :desktop)

    if @config["mobile"]
      generate_mock(mobile_page, details, mobile_html_path, mobile_png_path, :mobile)
      final_mobile_mock(mobile_png_path, file_name)
    end
  end

  unless ARGV[2] == "debug"
    File.delete("#{@dir_name}/index.html") if File.file?("#{@dir_name}/index.html")
    File.delete("#{@dir_name}/close.svg") if File.file?("#{@dir_name}/close.svg")
    File.delete("#{@dir_name}/robots.txt")if File.file?("#{@dir_name}/robots.txt")
  end
end

def generate_mock(page, details, html_path, png_path, platform)
  mock_code = make_mock(page, details, platform)

  if mock_code
    write_mock_code_to_file(html_path, mock_code)

    if platform == :desktop
      phantomjs_desktop_screenshot(html_path, png_path)
    elsif platform == :mobile
      phantomjs_mobile_screenshot(html_path, png_path)
    end

    File.delete(html_path) unless ARGV[2] == "debug"
  end
end

def final_mobile_mock(mock_png, file_name)
  mock_code = InjectionManager.get_injection(:MobileMockInjection, mock_png)
  html_path = "#{@dir_name}/#{file_name}_mobile.html"
  png_path = "#{@dir_name}/#{file_name}_mobile.png"

  write_mock_code_to_file(html_path, mock_code)
  phantomjs_desktop_screenshot(html_path, png_path)

  File.delete(html_path) unless ARGV[2] == "debug"
  File.delete(mock_png) unless ARGV[2] == "debug"
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

def make_mock(page, details, platform)
  return unless @config["asset_path"]
  return unless File.file?("#{@config["asset_path"]}/#{details[:resource]}")

  first_half, second_half = page.split("</body>")
  resource_path = "#{@config["asset_path"]}/#{details[:resource]}"

  injection_code = ""
  details[:injections].each do |injection|
    injection_code += InjectionManager.get_injection(injection, resource_path) if platform == :desktop
    injection_code += InjectionManager.get_mobile_injection(injection, resource_path) if platform == :mobile
  end
  first_half + injection_code + "</body> #{second_half}"
end

def write_mock_code_to_file(full_path, code)
  open(full_path, 'w') { |f|
    f.puts code
  }
end

def phantomjs_desktop_screenshot(html_path, png_path)
  screenshot(`phantomjs screengrabber_desktop.js #{html_path} #{png_path}`, png_path)
end

def phantomjs_mobile_screenshot(html_path, png_path)
  screenshot(`phantomjs screengrabber_mobile.js #{html_path} #{png_path}`, png_path)
end

def screenshot(command, png_path)
  puts "Benchmark: #{png_path}"
  Benchmark.bm do |x|
    x.report { command } unless ARGV[1] == "skip"
  end
  puts "Done phantomjs for #{png_path}"
end

global_config["sites"].each do |site|
  create_mocks(site)
end
