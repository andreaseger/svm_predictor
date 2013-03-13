require 'sinatra/base'
require 'sinatra/json'
require 'json'

module SvmPredictor
  class Api < Sinatra::Base
    helpers Sinatra::JSON

    set :root, File.dirname(__FILE__)
    set :public_folder, File.join(root, 'public')

    get '/' do
      json hello: "World"
    end
    post '/echo' do
      data = JSON.parse(request.body.read)
      json echo: data
    end
    post '/predict' do
      data = JSON.parse(request.body.read)
      # TODO
      json correct: false, probability: 0.76
    end
  end
end
# Run the app!
#
puts "Hello, you're running your web app from a gem!"
SvmPredictor::Api.run!