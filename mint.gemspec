require "tilt"
require File.expand_path("../lib/mint/version", __FILE__)

Gem::Specification.new do |s|
  s.specification_version = 3 if s.respond_to? :specification_version
  s.required_rubygems_version = ">= 1.3.6"
  
  s.name      = "mint"
  s.version   = Mint::VERSION
  
  s.platform  = Gem::Platform::RUBY
  s.homepage  = "http://github.com/davejacobs/mint"
  s.author    = "David Jacobs"
  s.email     = "david@wit.io"
  s.summary   = "Clean, simple library for maintaining and styling documents without a word processor"
  s.description = "Clean, simple library for maintaining and styling documents without a word processor. Mint aims to bring the best of the Web to desktop publishing, to be completely flexible, and to let the user decide what his workflow is like. A powerful plugin system means almost any conceivable publishing target is an option."

  s.files = Dir["{bin,config,lib,plugins}/**/*"] + [
    "README.md",
    "Gemfile"
  ]

  s.test_files = Dir["{features,spec}/**/*"]

  s.require_path = "lib"
  s.executables  = ["mint", "mint-epub"]

  s.add_dependency "tilt"
  s.add_dependency "rdiscount"
  s.add_dependency "erubis"
  s.add_dependency "haml"
  s.add_dependency "sass"
  s.add_dependency "rdiscount"
  s.add_dependency "liquid"
  s.add_dependency "less"
  s.add_dependency "radius"
  s.add_dependency "markaby"
  s.add_dependency "active_support"
  s.add_dependency "nokogiri"
  s.add_dependency "hashie"
  s.add_dependency "rubyzip"
  s.add_development_dependency "rspec"
  s.add_development_dependency "cucumber"
  s.add_development_dependency "aruba"
end
