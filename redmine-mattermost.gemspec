# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "redmine_mattermost/version"
require "redmine_mattermost/infos"

Gem::Specification.new do |spec|
  spec.name          = "redmine-mattermost"
  spec.version       = RedmineMattermost::VERSION
  spec.authors       = RedmineMattermost::Infos::AUTHORS
  spec.summary       = RedmineMattermost::Infos::DESCRIPTION
  spec.description   = RedmineMattermost::Infos::DESCRIPTION
  spec.homepage      = RedmineMattermost::Infos::URL
  spec.license       = RedmineMattermost::Infos::LICENSE

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", "~> 4.2.0"
  spec.add_dependency "reverse_markdown", "~> 1.0.3"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.9.0"
  spec.add_development_dependency "webmock", "~> 2.1.0"
  spec.add_development_dependency "RedCloth", "~> 4.3.2"
end
