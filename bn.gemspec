require "pathname"

Gem::Specification.new do |s|
  # Variables
  s.summary     = "A Battle.net API adapter and entity mapper."
  s.license     = "MIT"

  # Dependencies
  s.add_dependency "version", "~> 1.0.0"
  s.add_dependency "httpi", "~> 2.4.1"
  s.add_dependency "ffi", "~> 1.9.10"
  s.add_dependency "aspect", "~> 0.0.2"

  # Pragmatically set variables and constants
  s.author        = "Ryan Scott Lewis"
  s.email         = "ryan@rynet.us"
  s.homepage      = "http://github.com/RyanScottLewis/#{s.name}"
  s.version       = Pathname.glob("VERSION*").first.read rescue "0.0.0"
  s.description   = s.summary
  s.name          = Pathname.new(__FILE__).basename(".gemspec").to_s
  s.require_paths = ["lib"]
  s.files         = Dir["{Rakefile,Gemfile,README*,VERSION,LICENSE,*.gemspec,{lib,bin,examples,spec,test}/**/*}"]
  s.test_files    = Dir["{examples,spec,test}/**/*"]
end
