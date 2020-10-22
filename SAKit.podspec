Pod::Spec.new do |spec|
  spec.name = "SAKit"
  spec.version = "1.0.0"
  spec.summary = "Simplify developer"
  spec.homepage = "https://codeup.aliyun.com/5eb53cca38076f00011bcfd8/IOS/SAKit"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Fan Li Lin" => '824589131.com' }
  spec.platform = :ios, "9.0"
  spec.requires_arc = true
  spec.source = { git: "https://codeup.aliyun.com/5eb53cca38076f00011bcfd8/IOS/SAKit.git", tag: spec.version, submodules: true }
  spec.public_header_files = "SAKit/SAKit.h"
  spec.source_files = "SAKit/SAKit.h"
  spec.libraries = "bz2"
  spec.dependency "AFNetworking", '~> 3.0'
  spec.dependency "SSZipArchive"
  
  spec.subspec "FileDownloader" do |ss|
    ss.source_files = "SAKit/FileDownloader/**/*"
  end
  
  spec.subspec "FilePreview" do |ss|
    ss.source_files = "SAKit/FilePreview/**/*"
  end
  
  spec.subspec "Vender" do |ss|
    ss.source_files = "SAKit/Vender/**/*"
  end
  
  spec.subspec "Router" do |ss|
    ss.source_files = "SAKit/Router/**/*"
  end
  
end
