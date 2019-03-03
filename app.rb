require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require 'sinatra/activerecord'
require './models'

enable :sessions

helpers do
  def current_user
    User.find_by(id: session[:user])
  end
end


get '/' do
  erb :index
end

get '/signup' do
  erb :sign_up
end

post '/signup' do
  @user = User.create(name:params[:name],password:params[:password],password_confirmation:params[:password_confirmation])

if @user.persisted?
  session[:user] = @user.id
end

redirect '/'
end

post '/signin' do
user = User.find_by(name: params[:name])
  if user && user.authenticate(params[:password])
    session[:user] = user.id
  end
  redirect '/'
end

get '/signout' do
  session[:user] = nil
  redirect '/'
end

#homeにいく。
get '/home' do
  @categories = Category.all
  if current_user.nil?
    @quests = Quest.none
  elsif params[:category].nil?
    @quests = current_user.quests
  else
    @quests = Category.find(params[:list]).quests.where(user_id: current_user.id)
  end
  erb :home
end

#投稿のフォームにいく。
get '/actnew' do
  erb :act_new
end

post '/new' do

  Quest.create(
    title: params[:title],
    client: params[:client],
    condition: params[:condition],
    member: params[:member],
    details: params[:details],
    star: params[:star],
    user_id: current_user.id,
    user_name: current_user.name)

redirect '/home'
end


get '/new/delete/:id' do
  Quest.find(params[:id]).delete
  redirect '/home'
end
