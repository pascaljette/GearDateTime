#
# Be sure to run `pod lib lint GearKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "GearDateTime"
  s.version          = "0.1"
  s.summary          = "Date, Calendar and Components wrapper/shortcut for easy date management."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
Date, Calendar and Components wrapper/shortcut for easy date management.
This provides a .NET-like framework for manipulating DateTime objects using
Swift instead of C#.
                       DESC

  s.homepage         = "https://github.com/pascaljette/GearDateTime"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Pascal Jette" => "pascal.jette@gmail.com" }
  s.source           = { :git => "https://github.com/pascaljette/GearDateTime.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'GearDateTime/**/*'
  #s.resource_bundles = {
  #  'GearKit' => ['Assets/*.png']
  #}

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
end
