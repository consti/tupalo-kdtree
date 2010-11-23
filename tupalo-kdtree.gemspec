# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{tupalo-kdtree}
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Adam Doppelt", "Andreas Fuchs"]
  s.date = %q{2010-11-23}
  s.description = %q{Tupalo-kdtree is a thread-safe fork of the kdtree Gem by Adam Doppelt.}
  s.extensions << 'ext/extconf.rb'
  s.email = %q{developers@tupalo.com}
  s.extra_rdoc_files = [
    "LICENSE"
  ]
  s.files = [
    "LICENSE",
    "ext/extconf.rb",
    "ext/kdtree.c",
    "test/test.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/consti/tupalo-kdtree}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Tupalo-kdtree is a thread-safe fork of the kdtree Gem by Adam Doppelt.}
  s.test_files = [
    "test/test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
