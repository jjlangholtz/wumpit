class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :room
      t.integer :player

      t.timestamps
    end
  end
end
