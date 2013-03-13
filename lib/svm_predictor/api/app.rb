require 'sinatra/base'
require 'sinatra/json'
require 'json'

require 'svm_predictor'

module SvmPredictor
  class Api < Sinatra::Base
    helpers Sinatra::JSON

    set :root, File.dirname(__FILE__)
    set :public_folder, File.join(root, 'public')

    set :config, JSON.parse(IO.read('config.json'))
    set :function_predictor, SvmPredictor.load_file(config['function_predictor'])
    set :industry_predictor, SvmPredictor.load_file(config['industry_predictor'])
    set :career_level_predictor, SvmPredictor.load_file(config['career_level_predictor'])

    get '/' do
      json hello: "World"
    end
    post '/echo' do
      data = JSON.parse(request.body.read)
      json echo: data
    end
    post '/predict' do
      data = JSON.parse(request.body.read)
      function = function_predictor.predict(data['title'], data['description'], data['function_id']) if function_predictor
      industry = industry_predictor.predict(data['title'], data['description'], data['industry_id']) if industry_predictor
      career_level = career_level_predictor.predict(data['title'], data['description'], data['career_level_id']) if career_level_predictor
      json function: function, industry: industry, career_level: career_level
    end
  end
end
# Run the app!
#
puts "Hello, you're running your web app from a gem!"
SvmPredictor::Api.run!
