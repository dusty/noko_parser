Gem::Specification.new do |s| 
  s.name = "noko_parser" 
  s.version = "0.0.9"
  s.author = "Dusty Doris" 
  s.email = "github@dusty.name" 
  s.homepage = "http://code.dusty.name" 
  s.platform = Gem::Platform::RUBY 
  s.summary = "Wrapper around Nokogiri to easily parse xml files with xpath" 
  s.has_rdoc = true 
  s.extra_rdoc_files = ["README.txt"]
  s.add_dependency('nokogiri')
  s.rubyforge_project = "none"
  s.files = %w{
    README.txt
    examples/monkey.rb
    examples/monkeys.xml
    lib/noko_parser.rb
    lib/noko_parser/parser.rb
    lib/noko_parser/properties.rb
    test/test_noko_parser.rb
  }
end
