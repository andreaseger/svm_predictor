require 'bundler'
Bundler.setup
Bundler.require(:default, :test)
print `rvm current`
require 'svm_predictor'

RSpec.configure do |config|
  config.mock_with :mocha

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.filter_run_excluding :slow => true

  config.before(:suite) { FileUtils.mkdir_p('tmp/spec') unless File.directory?('tmp/spec') }
  config.before(:each) do
    FileUtils.rm Dir.glob('tmp/spec/*')
    Timecop.return
  end
  config.after(:suite) { FileUtils.rmdir('tmp/spec') }
end
