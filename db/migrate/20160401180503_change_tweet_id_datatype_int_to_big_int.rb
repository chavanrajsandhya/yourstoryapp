class ChangeTweetIdDatatypeIntToBigInt < ActiveRecord::Migration
  def change
  	change_column :tweets, :id, :bigint
  end
end
