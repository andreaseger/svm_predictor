require 'sinatra/base'
require 'sinatra/json'
require 'json'

require 'svm_predictor'

module SvmPredictor
  class Api < Sinatra::Base
    helpers Sinatra::JSON

    set :root, File.dirname(__FILE__)
    set :public_folder, File.join(root, 'public')

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
