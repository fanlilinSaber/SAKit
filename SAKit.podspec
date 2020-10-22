Pod::Spec.new do |spec|
  spec.name = "SAKit"
  spec.version = "1.0.0"
  spec.summary = "Simplify developer"
  spec.homepage = "https://codeup.aliyun.com/5eb53cca38076f00011bcfd8/IOS/SAKit"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Fan Li Lin" => '824589131.com' }
  spec.platform = :ios, "9.0"
  spec.requires_arc = true
  spec.source = { git: "git@github.com:fanlilinSaber/SAKit.git", tag: spec.version, submodules: true }
  spec.public_header_files = 'SAKit/SAKit.h'
  spec.source_files = 'SAKit/*.{h,m}', 'SAKit/BSDIFF/*.{h,m,c}', 'SAKit/FileDownloader/*.{h,m}', 'SAKit/FilePreview/*.{h,m}', 'SAKit/Vender/**/*.{h,m}'
  spec.resources = "SAKit/*.bundle"
  spec.libraries = "bz2"
  spec.dependency "AFNetworking", '~> 3.0'
  spec.dependency "SSZipArchive", '2.2.2'
end
