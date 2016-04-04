class Changetweetcreatedattype < ActiveRecord::Migration
  def up
  	change_column :tweets, :tweet_created_at, :time
  end

  def down
  	change_column :tweets, :tweet_created_at, :datetime
  end
end
