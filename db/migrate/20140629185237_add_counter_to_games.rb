class AddCounterToGames < ActiveRecord::Migration
  def change
    add_column :games, :counter, :integer
  end
end
