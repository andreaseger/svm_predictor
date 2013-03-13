require 'sinatra'
require 'sinatra/json'

module SvmPredictor
  class Api < Sinatra::Base
    set :root, File.dirname(__FILE__)
    set :public_folder, File.join(root, 'public')

    get '/' do
      json hello: "World"
    end
  end
end
# Run the app!
#
puts "Hello, you're running your web app from a gem!"
SvmPredictor::Api.run!