class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable, :validatable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable

  has_many :tweets

 def self.from_omniauth(auth, signed_in_resource=nil)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        # user.email = auth.info.email if auth.info.email
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
    client_object.home_timeline.each do |tweet|
      #create tweets table. define relationships, save required columns to tweets table
      uid = client_object.status(tweet).to_h[:user][:id]
      user_name = client_object.status(tweet).to_h[:user][:name]
      tweet_ids = self.tweets.pluck(:id)  
      unless tweet_ids.include?(tweet.id)
        begin
      	  self.tweets.create(id: tweet.id, uid: uid, user_name: user_name, content: tweet.text.encode("UTF-8"), tweet_created_at: tweet.created_at)                     
        rescue
        end
      end
    end
    current_user_tweets = Tweet.where(uid: self.uid.to_i)
    get_link_tweets(current_user_tweets)
  end

  def get_link_tweets(current_user_tweets)
    contents_with_link = []
    # raise current_user_tweets.inspect
    current_user_tweets.where(tweet_created_at: 7.days.ago..Time.now).each do |tweet|
      if (tweet.content.match(/(<a>.*<\/a>|http)/))  
        contents_with_link << tweet
      end
    end
    contents_with_link
  end

  def self.most_shared_links
    user_name_with_count = Hash.new(0)
    Tweet.all.each do |tweet|
      if (tweet.content.match(/(<a>.*<\/a>|http)/))
        # raise tweet.uid.inspect
        user_name_with_count[tweet.user_name] += 1
        # raise user_name_with_count.inspect
        # @tweet_with_links << tweet
      end
      #return the key which is having highest count
    end
    user_name_with_count
      # raise user_name_with_count.inspect

    #@tweet_with_links = []
    # @tweets.each do |tweet|
    #   if (tweet.content.match(/(<a>.*<\/a>|http)/))
    #     @tweet_with_links << tweet
    #   end
    # end
    # @user_ids = []
    # @tweet_with_links.each do |t|
    #   @user_ids << t.uid  
    # end
    # # user_ids << @tweet_with_links.pluck(:uid)
    # @user_ids.each do |uid|
    #   @tweets_count << Tweet.where(uid: uid).count
    #   @max_count = @tweets_count.max
    # end
    # @max_count
  end

  def self.domain_list
    content_with_links = []

    Tweet.all.each do |tweet|
      if (tweet.content.match(/(<a>.*<\/a>|http)/))
        content_with_links << tweet
      end
    end
    domains = []
    content_with_links.each do |link|
      url = URI.extract(link.content)
      puts link.content
      ur = url[1]
      uri = URI(ur.to_s)
      domains << uri.host
    end
    domains
  end

end