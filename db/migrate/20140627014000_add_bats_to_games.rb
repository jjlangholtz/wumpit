class AddBatsToGames < ActiveRecord::Migration
  def change
    add_column :games, :bat_one, :integer
    add_column :games, :bat_two, :integer
  end
end
