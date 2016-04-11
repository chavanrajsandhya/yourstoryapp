class AddUserNameToTweets < ActiveRecord::Migration
  def up
  	add_column :tweets, :user_name, :string
  end
end
