class DashboardController < ApplicationController
	# before_action :authenticate_user!

	def index
		# raise current_user.inspect
    	# name = auth.info.nickname
    	# raise current_user.client_config.inspect
    	@tweets = current_user.save_tweets#client_config.home_timeline

  	end
end
