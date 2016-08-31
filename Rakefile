require 'rubygems'
gem 'rake-compiler'
require 'rake/extensiontask'
BASE_DIR = Dir.pwd
require 'rubygems/package_task'
require 'rake/testtask'

$: << './lib'

require 'xsettings/version'
exts = []

namespace :prepare do
FileList["ext/*/*.cr"].each do |cr|
	dir = File.dirname(cr)
	name = File.basename(dir)
	desc "Generate source for #{name}"
	task(name.intern) do
		sh 'rubber-generate', '--build-dir', dir, cr
	end
end
end

spec = Gem::Specification.new do |s|
	s.name = "xsettings-ruby"
	s.author = "Geoff Youngs"
	s.email = "git@intersect-uk.co.uk"
	s.version = XSettings::VERSION
	s.homepage = "http://github.com/geoffyoungs/xsettings-ruby"
	s.summary = "xsettings bindings using rubber-generate"
	s.add_dependency("rubber-generate", ">= 0.0.17")
  s.add_dependency("gtk2", ">= 2.0.0")
  s.license = 'LGPL-2'
  s.platform = Gem::Platform::RUBY
	s.extensions = FileList["ext/*/extconf.rb"]
	s.files = FileList['ext/*/*.{c,h,cr,rd}'] + ['Rakefile', 'README.md'] + FileList['lib/**/*.rb']
s.description = <<-EOF
XSettings Manager bindings for ruby

e.g
require 'gtk2'
require 'xsettings-ruby'

EOF
end
Gem::PackageTask.new(spec) do |pkg|
    pkg.need_tar = true
end
Rake::ExtensionTask.new("xsettings", spec)

Rake::TestTask.new do |t|
	t.test_files = FileList['test/*_test.rb']
end

task :default, :compile

