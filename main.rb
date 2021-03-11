require 'sinatra'
require 'pg'
require 'bcrypt'
require 'json'

def maps_api_key()
  return ENV['MAPS_JS_API_LOCAL_KEY']
end

if development?
  require 'sinatra/reloader'
  require 'pry'
end

def run_sql(str,arr = [])
  db = PG.connect(ENV['DATABASE_URL'] || {dbname: 'fishing_spots_app_db'})
  results = db.exec_params(str, arr)
  db.close
  return results
end

enable :sessions # enables a global 'like' object named session

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

  locations = run_sql('SELECT post_id, location_name, lng, lat FROM posts;').to_a.to_json
  

  erb :index, locals:{locations: locations}
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

  user_posts = run_sql('SELECT * FROM posts WHERE user_id = $1',[params[:user_id]])

  erb :user_profile, locals:{user_posts: user_posts, user_id: params[:user_id]}
end

get '/post/create' do

  erb :create_post_page
end

get '/post/:post_id' do

  post = run_sql('SELECT * FROM posts WHERE post_id = $1',[params[:post_id]])[0]

  erb :post_details_page, locals:{post: post}
end

post '/post' do

  run_sql('INSERT INTO posts (location_name, target_fish, best_bait, best_lures, best_times, about, lng, lat, user_id, post_created) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);',[params[:location_name], params[:target_fish], params[:best_bait], params[:best_lures], params[:best_times], params[:about], params[:lng], params[:lat], params[:user_id], Time.now])

  redirect "/user/#{current_user['user_id']}"
end

delete '/post' do
  run_sql('DELETE FROM posts WHERE post_id = $1', [params[:post_id]])
  redirect "/user/#{current_user['user_id']}"
end

