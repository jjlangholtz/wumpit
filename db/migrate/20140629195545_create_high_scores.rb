class CreateHighScores < ActiveRecord::Migration
  def change
    create_table :high_scores do |t|
      t.string :name
      t.integer :moves
      t.integer :seconds

      t.timestamps
    end
  end
end
