require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "very_nifty_generators"
    gem.summary = %Q{Rails 3 nifty generators}
    gem.description = %Q{Rails 3 nifty generators, based on efforts by ryanb and dvyjones}
    gem.email = "kmandrup@gmail.com"
    gem.homepage = "http://github.com/kristianmandrup/very_nifty_generators"
    gem.authors = ["Kristian Mandrup, dvyjones"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.files=FileList['lib/**/*.*', 'bin/*']  
    
    gem.default_executable = %q{nifty_scaffold}
    gem.executables = ["nifty_scaffold", "nifty_auth", "nifty_config", "nifty_layout", "nifty_controller"]          
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "very_nifty_generators #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
