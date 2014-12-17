class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
    	t.integer :week
    	t.integer :points, :default => 0
    	t.integer :for_league_id
    	t.integer :player_id
    end
  end
end
