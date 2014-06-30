class AddTimerToGames < ActiveRecord::Migration
  def change
    add_column :games, :timer, :integer
  end
end
