Pod::Spec.new do |s|
s.name             = 'AMPasscodeView'  
s.version          = '0.0.1'  
s.summary          = 'A simple customisable passcode view' 
s.homepage         = 'https://github.com/Amian/PasscodeView'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'username' => 'anu_s_m@hotmail.com' }
s.source           = { :git => 'https://github.com/Amian/PasscodeView.git', :tag => s.version }
s.ios.deployment_target = '13.0'
s.source_files = 'src/*'
s.swift_versions = ['5.0']
end