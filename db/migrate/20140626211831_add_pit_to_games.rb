class AddPitToGames < ActiveRecord::Migration
  def change
    add_column :games, :pit_one, :integer
    add_column :games, :pit_two, :integer
  end
end
