Gem::Specification.new do |s| 
  s.name = "noko_parser" 
  s.version = "0.0.9"
  s.author = "Dusty Doris" 
  s.email = "github@dusty.name" 
  s.homepage = "http://code.dusty.name" 
  s.platform = Gem::Platform::RUBY 
  s.summary = "Wrapper around Nokogiri to easily parse xml files with xpath" 
  s.files = Dir["{test,lib,examples}/**/*"]
  s.has_rdoc = true 
  s.extra_rdoc_files = ["README.txt"]
  s.add_dependency('nokogiri')
  s.rubyforge_project = "none"
end
