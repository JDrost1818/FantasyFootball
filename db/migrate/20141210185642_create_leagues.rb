class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.string :description
      t.string :name
      t.integer :salary_cap

      t.timestamps
    end
  end
end
