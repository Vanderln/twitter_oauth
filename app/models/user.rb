class User < ActiveRecord::Base
  
  def twitter_client
    @twitter_client ||= Twitter::Client.new(
        :oauth_token => self.oauth_token,
        :oauth_token_secret => self.oauth_secret
      )
  end  
end
