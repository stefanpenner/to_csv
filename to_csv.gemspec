# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "to_csv/version"

Gem::Specification.new do |s|
  s.name        = "to_csv"
  s.version     = ToCsv::VERSION
  s.authors     = ["Stefan Penner"]
  s.email       = ["stefan.penner@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Ruby model CSV generation DSL}
  s.description = %q{yet another ruby to csv dsl, still at the having fun stage}

  s.rubyforge_project = "to_csv"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"

  s.add_runtime_dependency 'activesupport', '>= 3.1'
  # s.add_runtime_dependency "rest-client"
end
