source 'https://rubygems.org'

# Specify your gem's dependencies in predictor_api.gemspec
gemspec

# platforms :jruby do
#   gem "jrb-libsvm", '~>0.1.2'
# end
platforms :ruby do
  gem "rb-libsvm", '~>1.1.2',  github: 'sch1zo/rb-libsvm', require: 'libsvm'
end

group :development do
#  gem 'thin'
  gem 'pry'
  gem 'guard-rspec'

  gem 'rb-inotify', '~> 0.9', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false
end

group :test do
  gem 'rake'
  gem 'rspec'
  gem 'mocha', require: 'mocha/api'
  gem 'timecop'
end
