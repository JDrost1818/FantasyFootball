class Player < ActiveRecord::Base
	has_many :stats
	has_and_belongs_to_many :teams

	def full_name
		first_name + " " + last_name
	end
end
