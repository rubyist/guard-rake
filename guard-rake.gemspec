# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'guard/rake/version'

Gem::Specification.new do |s|
  s.name        = 'guard-rake'
  s.version     = Guard::RakeVersion::VERSION
  s.authors     = ['Scott Barron']
  s.email       = ['scott@elitists.net']
  s.homepage    = 'http://github.com/rubyist/guard-rake'
  s.summary     = %q{Guard for running rake tasks}
  s.description = %q{guard-rake automatically runs Rake tasks from your Rakefile}

  s.add_dependency 'guard'
  s.add_dependency 'rake'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map {|f| File.basename(f) }
  s.require_paths = ['lib']
end

