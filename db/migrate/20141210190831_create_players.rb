class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :first_name
      t.string :last_name
      t.string :position
      t.string :nfl_team
      t.integer :salary
      t.integer :team_id

      t.timestamps
    end
  end
end
