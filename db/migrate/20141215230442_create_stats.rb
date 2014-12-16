class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
    	t.integer :week
    	t.integer :points, :default => 0
    end
  end
end
