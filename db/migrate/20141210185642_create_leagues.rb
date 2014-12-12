class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.integer :league_owner_id
      t.string :description
      t.string :name
      t.integer :salary_cap
      t.boolean :is_open_for_registration, :default => true

      t.timestamps
    end
  end
end
