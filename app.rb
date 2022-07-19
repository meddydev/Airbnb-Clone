require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/database_connection'
require_relative 'lib/space_repository'
require_relative 'lib/user_repository'

DatabaseConnection.connect("makersbnb_test")

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
  end

  enable :sessions
  
  get "/" do
    return erb(:index)
  end

  get "/login" do
    return erb(:login)
  end

  post "/signup" do
    email = params[:email]
    repo = UserRepository.new
    if repo.find_by_email(email) == nil
      new_user = User.new
      new_user.name = params[:name]
      new_user.email = params[:email]
      new_user.password = params[:password]
      
      repo.create(new_user)

      return erb(:signup_success)
    else
      return erb(:signup_fail)
    end
  end

  post "/login" do
    email = params[:email]
    password = params[:password]

    repo = UserRepository.new
    user = repo.find_by_email(email)

    if repo.find_by_email(email) == nil || user.password != password
      return erb(:login_fail)
    else
      session[:user_id] = user.id
      return erb(:login_success)
    end
  end

  get "/account_page" do
    return "hello"
  end
end

