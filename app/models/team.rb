class Team < ActiveRecord::Base
	belongs_to :league
	belongs_to :user

	has_and_belongs_to_many :players

	def get_record
	    "16-0"
	end
end
