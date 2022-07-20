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
    if session[:user_id] != nil
      session.delete(:user_id)
    end
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
    @user = repo.find_by_email(email)

    if repo.find_by_email(email) == nil || @user.password != password
      return erb(:login_fail)
    else
      session[:user_id] = @user.id
      return erb(:login_success)
    end
  end

  get "/account_page" do
    if session[:user_id] == nil
      return redirect('/login')
    else
      repo_user = UserRepository.new
      @user = repo_user.find(session[:user_id])
      repo_space = SpaceRepository.new
      @spaces = repo_space.all
      return erb(:account_page)
    end
  end

  get "/add_space" do
   return erb(:add_space)
  end

  post "/add_space" do
    if session[:user_id] == nil
      return redirect('/login')
    else
      @user_id = session[:user_id]
      repo = SpaceRepository.new
      new_space = Space.new
      new_space.title = params[:title]
      new_space.description = params[:description]
      new_space.price_per_night = params[:price_per_night]
      new_space.available_from_date = params[:available_from_date]
      new_space.available_to_date = params[:available_to_date]
      new_space.owner_id = session[:user_id].to_s
      
      repo.create(new_space)
      
      return redirect('/account_page')
    end
  end

  get "/spaces/:id" do
    id = params[:id]
    space_repo = SpaceRepository.new
    @space = space_repo.find(id)
    repo_user = UserRepository.new
    @user = repo_user.find(@space.owner_id)
    return erb(:spaces_info)
  end

end