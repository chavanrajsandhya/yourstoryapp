class DashboardController < ApplicationController
	# before_action :authenticate_user!

	def index
		@tweets = current_user.save_tweets
  	end

  	def actual_tweets
  		@actual_tweets = current_user.tweets.count
  	end
end
