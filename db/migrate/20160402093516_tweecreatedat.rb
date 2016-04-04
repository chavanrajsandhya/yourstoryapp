class Tweecreatedat < ActiveRecord::Migration
  def change
  	add_column :tweets, :tweet_created_at, :time
  end
end
