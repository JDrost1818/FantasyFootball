class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.integer :league_owner_id
      t.string :description
      t.string :name
      t.integer :salary_cap, :default => 75000
      t.boolean :is_open_for_registration, :default => true
      t.integer :current_week, :default => 1

      t.timestamps
    end
  end
end
