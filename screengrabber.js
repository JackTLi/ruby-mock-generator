var page = require('webpage').create();
system = require('system');
var width = 1920;
var height = 1080;
page.viewportSize = { width: width, height: height };
page.settings.javascriptEnabled = true;

page.open('file:///Users/ruby/Documents/Scripts/ruby-mock-generator/' + system.args[1], function() {
  page.clipRect = { top: 0, left: 0, width: width, height: height };
  page.render(system.args[2]);
  phantom.exit();
});
