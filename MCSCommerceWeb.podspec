Pod::Spec.new do |s|
  s.name         = "MCSCommerceWeb"
  s.version      = "1.1.1"
  s.summary      = "Objective-C iOS wrapper for Mastercard's web SRC Initiator"
  s.homepage     = "https://github.com/Mastercard/MCSCommerceWeb"
  s.license      = "Apache License, Version 2.0"
  s.author             = { "Bret Deasy" => "bjdeasy@gmail.com" }
  s.platform     = :ios, "11.0"
  s.ios.vendored_frameworks = "MCSCommerceWeb.framework"
  s.source       = { :http => "https://github.com/Mastercard/MCSCommerceWeb/blob/release/1.1.1/MCSCommerceWeb.zip?raw=true" }
  s.exclude_files = "Classes/Exclude"
  s.dependency 'SVGKit', '3.0.0beta3'
end
