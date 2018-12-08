Pod::Spec.new do |s|
  s.name = "DynuREST"
  s.version = "1.2.0"
  s.summary = "An API wrapper for the Dynu.com IP Update API which attempts to model text responses to HTTP Status Codes."
  s.description = <<-DESC
  Face it... a REST API that responds in only text doesn't feel very modern. DynuREST attempts to translate the text
  responses from the Dynu.com IP Update API into propery HTTP status codes and meaningful errors.
                       DESC
  s.homepage = "https://github.com/richardpiazza/DynuREST"
  s.license = 'MIT'
  s.author = { "Richard Piazza" => "github@richardpiazza.com" }
  s.social_media_url = 'https://twitter.com/richardpiazza'

  s.source = { :git => "https://github.com/richardpiazza/DynuREST.git", :tag => s.version.to_s }
  s.source_files = 'Sources/*'
  s.requires_arc = true
  s.platforms = { :osx => '10.13', :ios => '11.0', :tvos => '11.0', :watchos => '4.0' }
  s.frameworks = 'Foundation'
  s.dependency 'CodeQuickKit', '~> 6.4'

end
