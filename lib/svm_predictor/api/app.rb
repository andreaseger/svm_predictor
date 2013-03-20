require 'sinatra/base'
require 'sinatra/json'
require 'json'

require 'svm_predictor'

module SvmPredictor
  class Api < Sinatra::Base
    helpers Sinatra::JSON

    set :root, File.dirname(__FILE__)
    set :public_folder, File.join(root, 'public')
    enable :inline_templates

    def self.setup path='config/settings.json'
      path = File.expand_path(path)
      config = JSON.parse(IO.read(path))
      set :predictors,  Hash[%w(function industry career_level).map { |classification|
                          key = "#{classification}_predictor"
                          if config[key]
                            puts "loading #{key}..."
                            [
                              classification,
                              SvmPredictor::Model.load_file(
                                File.realdirpath(File.join(File.dirname(path), config['basedir'], config[key]))
                              )
                            ]
                          end
                        }.compact]
    end

    get '/settings.json' do
      response['Cache-Control'] = "public, max-age=60"
      json predictors:  settings.predictors.map { |classification,predictor|
                          {
                            id: predictor.id,
                            classification: classification,
                            properties: predictor.properties,
                            metrics: predictor.metrics
                          }
                        }
    end
    post '/predict' do
      data = JSON.parse(request.body.read)
      json results: settings.predictors.map { |classification, predictor|
                      next if data["#{classification}_id"].empty?
                      pred, prob = predictor.predict(data['title'],
                                                     data['description'],
                                                     data["#{classification}_id"].to_i)
                      {
                        classification: classification,
                        prediction: (pred==1 ? true : false),
                        probability: prob
                      }
                    }.compact
    end

    get '/' do
      response['Cache-Control'] = "public, max-age=60"
      erb :index
    end
    # get('/templates.json'){json Dir[File.join(settings.root,'templates/*')].map {|e| { name: File.basename(e, '.mustache').sub(/^_/,''), template: IO.read(e) }}}
  end
end

__END__
@@ index
<!DOCTYPE html>
<html class="no-js">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <title>Classification Verifier</title>
        <meta name="description" content="Classification Verifier">
        <meta name="viewport" content="width=device-width">

        <link rel="stylesheet" href="css/normalize.min.css">
        <link rel="stylesheet" href="css/main.css">

        <script src="js/vendor/modernizr-2.6.2.min.js"></script>
    </head>
    <body>
        <div class="header-container">
            <header class="wrapper clearfix">
                <h1 class="title">Classification Verifier</h1>
            </header>
        </div>
        <div class="main-container">:( JS not working... or slow</div>

        <script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
        <script>window.jQuery || document.write('<script src="js/vendor/jquery-1.9.1.min.js"><\/script>')</script>
        <script src="js/vendor/ICanHaz.min.js"></script>
        <script src="js/main.js"></script>
    </body>
</html>