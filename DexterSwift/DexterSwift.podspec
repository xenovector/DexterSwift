Pod::Spec.new do |spec|

  spec.name         = "DexterSwift"
  spec.version      = "1.0.2"
  spec.summary      = "A DexterSwift Library project for own and public use."
  spec.description  = <<-DESC
  There are a lot of useful extension that are free to be use.
  Kindly open up an issue if you find one, thanks.
                   DESC
  spec.homepage     = "https://github.com/xenovector/DexterSwift"
  spec.license      = "MIT"
  spec.author             = { "Dexter" => "dexter@etctech.com.my" }
  spec.platform     = :ios, "10.3"
  spec.source       = { :git => "https://github.com/xenovector/DexterSwift.git", :tag => "v#{spec.version}" }
  spec.swift_version = "5.0"
  spec.source_files = "DexterSwift/**/*"
  spec.exclude_files = ["DexterSwift/**/*.plist", "DexterSwift/**/*.xcuserstate"]
  spec.ios.deployment_target  = '10.3'

end
