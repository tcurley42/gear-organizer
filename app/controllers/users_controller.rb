class UsersController < ApplicationController
  register Sinatra::Flash

  get '/signup' do
    if logged_in?
      redirect '/home'
    else
      erb :'users/create_user.html'
    end
  end

  get '/login' do
    if logged_in?
      redirect '/home'
    else
      erb :'users/login.html'
    end
  end

  get '/logout' do
    if logged_in?
      session.clear

      redirect '/login'
    else
      redirect '/'
    end
  end

  post '/signup' do
    if params[:username].empty? || params[:email].empty? || params[:password].empty? || params[:name].empty?
      redirect '/signup'
    else
      @user = User.new(params)
      if @user.valid?
        @user.save
        session[:user_id] = @user.id

        redirect '/home'
      else
        errors = []
        @user.errors.messages.each do |key, value|
          errors << "#{key} #{value.first}"
        end
        flash[:errors] = errors
        redirect '/signup'
      end
    end
  end

  post '/login' do
    if params[:username].empty? || params[:password].empty?
      redirect to '/login'
    else
      user = User.find_by(username: params[:username])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect "/home"
      else
        redirect "/login"
      end
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    if @user
      erb :'users/show.html'
    else
      redirect '/'
    end
  end

  get '/home' do
    if !logged_in?
      redirect '/'
    else
      @user = current_user
      erb :'users/home.html'
    end
  end

  get '/users' do
    if !logged_in?
      redirect '/'
    else
      erb :'/users/index.html'
    end
  end
end
