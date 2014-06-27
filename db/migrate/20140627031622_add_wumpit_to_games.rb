class AddWumpitToGames < ActiveRecord::Migration
  def change
    add_column :games, :wumpit, :integer
  end
end
