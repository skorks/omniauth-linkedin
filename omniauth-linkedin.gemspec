# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "omniauth-linkedin/version"

Gem::Specification.new do |s|
  s.name        = "omniauth-linkedin"
  s.version     = Omniauth::Linkedin::VERSION
  s.authors     = ["Alan Skorkin"]
  s.email       = ["alan@skorks.com"]
  s.homepage    = "https://github.com/skorks/omniauth-linkedin"
  s.summary     = %q{LinkedIn strategy for OmniAuth.}
  s.description = %q{LinkedIn strategy for OmniAuth.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'omniauth-oauth', '~> 1.0'

  s.add_development_dependency 'rspec', '~> 2.7'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'rack-test'
end
