class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.integer :team_id
      t.integer :user_id
      t.integer :league_id
      t.string :name
      t.integer :total_salary

      t.timestamps
    end
  end
end
