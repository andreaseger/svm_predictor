require "bundler/gem_tasks"

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new('spec')

# If you want to make this the default task
task :default => :spec


desc "generate api templates"
task :generate_templates do
  require 'json'
  api_base = File.join(File.dirname(__FILE__), 'lib/svm_predictor/api')
  templates = Dir[File.join(api_base,'templates/*')].map {|e|
              { name: File.basename(e, '.mustache').sub(/^_/,''),
                template: IO.read(e) }
              }
  IO.write(File.join(api_base, 'public','templates.json'), templates.to_json)
end