require 'sinatra/base'
require 'sinatra/reloader'
# require_relative 'lib/database_connection'
require_relative 'lib/space_repository'
require_relative 'lib/user_repository'

# DatabaseConnection.connect("makersbnb_test")

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
  end
  
  get "/" do
    return erb(:index)
  end

  get "/login" do
    return erb(:login)
  end

end

