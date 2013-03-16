require 'sinatra/base'
require 'sinatra/json'
require 'json'

require 'svm_predictor'

module SvmPredictor
  class Api < Sinatra::Base
    helpers Sinatra::JSON

    set :root, File.dirname(__FILE__)
    set :public_folder, File.join(root, 'public')

    set :config, JSON.parse(IO.read(config_file))
    set :classifications, %w(function industry career_level)
    set :predictors, {}
    classifications.each do |classification|
      key = "#{classification}_predictor"
      if config[key]
        predictors[classification] = SvmPredictor::Model.load_file(config[key])
        p "#{key} loaded"
      end
    end

    get '/' do
      json hello: "World"
    end
    post '/predict' do
      data = JSON.parse(request.body.read)
      json Hash[settings.predictors.map { |classification, predictor|
        [ classification,
          predictor.predict(data['title'], data['description'], data["#{classification}_id"])]
      }]
    end
  end
end
