Pod::Spec.new do |spec|
  spec.name = "SAKit"
  spec.version = "1.0.1"
  spec.summary = "A delightful tool framework for Apple platforms"
  spec.homepage = "https://github.com/fanlilinSaber/SAKit"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Fan Li Lin" => '824589131.com' }
  spec.platform = :ios, "9.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/fanlilinSaber/SAKit.git", tag: spec.version, submodules: true }
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
