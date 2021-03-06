Gem::Specification.new do |s|
  s.name        = 'kiwi_api'
  s.version     = '0.0.0'
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.summary     = 'Kiwi API'
  s.description = 'Kiwi (previously known as Skypicker) Ruby API'
  s.author      = ['Rafael Ruiz Moreno']
  s.email       = 'raf.ruiz.moreno@gmail.com'
  s.files       = ['lib/kiwi_api.rb', 'Rakefile']
  s.files       += Dir['lib/kiwi_api/*']
  s.files       += Dir['lib/kiwi_api/*/*']
  s.license     = 'MIT'
  s.test_files  = Dir.glob('{spec/**/*}')

  s.add_development_dependency 'webmock', '~> 3.4'
  s.add_development_dependency "pry", "~> 0.10.4"

  s.add_runtime_dependency 'faraday'
  s.add_runtime_dependency 'hashie'
end
