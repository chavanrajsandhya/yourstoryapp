class DashboardController < ApplicationController
	before_action :authenticate_user!


	def index
		@tweets = current_user.save_tweets
  end

  def actual_tweets
  	@actual_tweets = Tweet.where(uid: current_user.uid).count
  end  	
end
