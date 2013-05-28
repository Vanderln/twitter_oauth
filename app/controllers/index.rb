get '/' do
  erb :index
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  
  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  session.delete(:request_token)
  p @access_token

  screen_name = @access_token.params[:screen_name]

  # at this point in the code is where you'll need to create your user account and store the access token
  
  if @user = User.find_by_username(screen_name)
    @user.update_attributes(:oauth_token => @access_token.token, 
                            :oauth_secret => @access_token.secret)
  else
    @user = User.create(:username => screen_name, 
                        :oauth_token => @access_token.token, 
                        :oauth_secret => @access_token.secret)
  end

  session[:user_id] = @user.id
  erb :index
  
end

post '/tweet' do
  tweet = params[:new_tweet]
  current_user.twitter_client.update(tweet)
  redirect to '/'
end

