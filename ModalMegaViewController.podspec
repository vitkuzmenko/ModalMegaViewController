Pod::Spec.new do |s|

  s.name         = "ModalMegaViewController"
  s.version      = "0.0.1"
  s.summary      = "Modal Mega ViewController"

  s.homepage     = "https://github.com/vitkuzmenko/ModalMegaViewController.git"

  s.license      = { :type => "Apache 2.0", :file => "LICENSE" }

  s.author             = { "Vitaliy" => "kuzmenko.v.u@gmail.com" }
  s.social_media_url   = "http://twitter.com/vitkuzmenko"

  s.ios.deployment_target = '8.0'

  s.source       = { :git => s.homepage, :tag => s.version.to_s }

  s.source_files  = "Source/*.swift"
  
  s.requires_arc = 'true'

  s.dependency 'PureLayout'

end
