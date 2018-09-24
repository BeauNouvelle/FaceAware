#
#  Be sure to run `pod spec lint FaceAware.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "FaceAware"
  s.version      = "1.5.0"
  s.summary      = "A UIImageView extension that focus on faces within an image."

  s.description  = <<-DESC
  An extension that gives UIImageView the ability to focus on faces within an image when using AspectFill.
                   DESC

  s.homepage     = "https://github.com/BeauNouvelle/FaceAware"
  s.screenshots  = "https://raw.githubusercontent.com/BeauNouvelle/FaceAware/master/Images/avatarExample.png", "https://raw.githubusercontent.com/BeauNouvelle/FaceAware/master/Images/largeExample.jpg"

  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author    = "Beau Nouvelle"
  s.social_media_url   = "http://twitter.com/BeauNouvelle"

  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/BeauNouvelle/FaceAware.git", :tag => "#{s.version}" }

  s.source_files  = "FaceAware/*.{swift}"
  s.exclude_files = "Classes/Exclude"

end
