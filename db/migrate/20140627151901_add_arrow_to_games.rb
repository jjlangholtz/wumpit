class AddArrowToGames < ActiveRecord::Migration
  def change
    add_column :games, :arrow, :integer
  end
end
