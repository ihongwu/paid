Pod::Spec.new do |s|
    s.name             = 'paid'
    s.version          = '1.0.0'
    s.summary          = 'Pinduoduo PAID 1.4 Plugin'
    s.description      = 'iOS implementation for PAID 1.4 identifier generation.'
    s.homepage         = 'http://example.com'
    s.license          = { :file => '../LICENSE' }
    s.author           = { 'Developer' => 'dev@example.com' }
    s.source           = { :path => '.' }
    s.source_files = 'Classes/**/*'
    s.public_header_files = 'Classes/**/*.h'
    s.dependency 'Flutter'
    s.platform = :ios, '9.0'
  end
  