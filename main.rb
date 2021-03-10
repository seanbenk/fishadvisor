require 'sinatra'
require 'pg'
require 'bcrypt'

if development?
  require 'sinatra/reloader'
  require 'pry'
end

enable :sessions # enables a global 'like' object named session

def run_sql(str,arr = [])
  db = PG.connect(ENV['DATABASE_URL'] || {dbname: 'fishing_spots_app_db'})
  results = db.exec_params(str, arr)
  db.close
  return results
end

def logged_in?()
  return session[:user_id]
end

def current_user()
  user = run_sql('SELECT * FROM users WHERE user_id = $1', [session[:user_id]])
  return user.first
end

def get_username(id)
  return run_sql('SELECT username FROM users WHERE user_id = $1', [id])[0]['username']
end

def valueExists?(table_name, key_name, value_name)
   
  run_sql('SELECT * FROM $1 WHERE $2 = $3',[table_name, key_name, value_name]).count;
end

get '/' do

  erb :index
end

get '/signup' do

  erb :signup_page
end

get '/login' do

  erb :login_page
end

post '/sessions' do
  
    user = run_sql('SELECT * FROM users WHERE email = $1', [params[:email]])

    if user.count == 1 && BCrypt::Password.new(user[0]['password_digest']) == params[:password]
      session[:user_id] = user[0]['user_id']
      redirect '/'
    else
      redirect '/login?login_failed=true'
    end
end

delete '/sessions' do

  session[:user_id] = nil

  redirect '/'

end

post '/user' do

  if !valueExists?('users', 'email', params[:email])
    redirect '/signup'

  else
    password_digest = BCrypt::Password.create(params[:password])

    run_sql("INSERT INTO users (username, email, password_digest) VALUES ($1, $2, $3)", [params[:username], params[:email], password_digest])

    redirect '/'
  end
end

get '/user/:user_id' do

  user = run_sql('SELECT * FROM posts WHERE user_id = $1',[params[:user_id]])

  erb :user_profile, locals:{user: user, user_id: params[:user_id]}
end

get '/post/create' do

  erb :create_post_page
end

get '/post/:post_id' do

  post = run_sql('SELECT * FROM posts WHERE post_id = $1',[params[:post_id]])[0]

  erb :post_details_page, locals:{post: post}
end

post '/post' do

  run_sql('INSERT INTO posts (title, blurb, spot_name, lng, lat, user_id) VALUES ($1, $2, $3, $4, $5, $6);',[params[:title], params[:blurb], params[:spot_name], params[:lng], params[:lat], params[:user_id]])
  
  redirect "/user/#{current_user['user_id']}"
end