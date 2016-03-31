class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :tweets

  def self.from_omniauth(auth, signed_in_resource=nil)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email if auth.info.email
        user.name = auth.info.nickname
        user.password = Devise.friendly_token[0,20]
        user.save
      end
  end

  def client_object
    Twitter::REST::Client.new do |config|
      config.consumer_key        = "eb7yfEHVLeAO0G7SOh53nCNqa"
      config.consumer_secret     = "vH9JybcsppJfQiEK5ZfzYl1apNNVVcMi2GTxuu9hvVslUZnonE"
      config.access_token        = "934095355-mwoRxJnVwZ8ZTRFzUjFuHjWcnOu5oZAl9uuhSIYa"
      config.access_token_secret = "RP2BMGlF2kgOzN8PDhaj5VTq4yUUXrv0UJnNj1PrtpXwv"
    end
  end

  def save_tweets
    # raise client_object.home_timeline.inspect
    client_object.home_timeline.each do |tweet|
       # user_tweet = client_object.status(tweet.id)
       user_tweet = tweet.text
       #create tweets table. define relationships, save required columns to tweets table
       self.tweets.create(content: user_tweet)
    end 
    tweets

  end
end
