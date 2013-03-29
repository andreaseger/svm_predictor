# Svm Predictor

shared helper class which saves settings of a preprocessing and feature selection.
Also can load a libsvm model to predict data.

## Dependencies

- although `svm_helper` is available as gem it is probably better to
require the current version from git

```
gem 'svm_helper', github: 'sch1zo/svm_helper'
```

## Installation

Add this line to your application's Gemfile:

    gem 'svm_predictor'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install svm_predictor

## Usage

``` ruby
SvmPredictor::Model.new svm: @svm,
                        preprocessor: Preprocessor::Simple.new,
                        selector: Selector::Simple.new,
                        classification: :function,
                        basedir: 'tmp/spec'
```

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
