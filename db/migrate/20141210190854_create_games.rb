class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :week
      t.integer :away_team_id
      t.integer :away_score, :default => 0
      t.integer :home_team_id
      t.integer :home_score, :default => 0
      t.boolean :is_finished

      t.timestamps
    end
  end
end
