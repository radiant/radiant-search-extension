# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "radiant-search-extension/version"

Gem::Specification.new do |s|
  s.name        = "radiant-search-extension"
  s.version     = RadiantSearchExtension::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Radiant CMS Dev Team"]
  s.email       = ["radiant@radiantcms.org"]
  s.homepage    = "http://radiantcms.org/"
  s.summary     = %q{Simple search for Radiant CMS}
  s.description = %q{An extension for Radiant CMS to support searching pages}

  ignores = if File.exist?(".gitignore")
    File.read(".gitignore").split("\n").inject([]) {|a,p| a + Dir[p] }
  else
    []
  end
  s.files         = Dir["**/*"] - ignores
  s.test_files    = Dir["test/**/*","spec/**/*","features/**/*"] - ignores
  s.require_paths = ["lib"]
end