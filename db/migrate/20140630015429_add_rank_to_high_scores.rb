class AddRankToHighScores < ActiveRecord::Migration
  def change
    add_column :high_scores, :rank, :integer
  end
end
