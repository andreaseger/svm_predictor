# Svm Predictor

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'svm_predictor'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install svm_predictor

## Usage

TODO: Write usage instructions here

### API

start with

    svm_predictor_api

then you can test with something like this

    curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d ' {"user":{"first_name":"firstname","last_name":"lastname","email":"email@email.com","password":"app123","password_confirmation":"app123"}}' localhost:4567/predict


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
