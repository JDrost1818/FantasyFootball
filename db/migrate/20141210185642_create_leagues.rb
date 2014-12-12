class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.integer :id
      t.string :description
      t.string :name
      t.integer :salary_cap

      t.timestamps
    end
  end
end
