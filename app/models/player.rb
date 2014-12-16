class Player < ActiveRecord::Base
	has_many :stats
	has_and_belongs_to_many :teams

	def full_name
		first_name + " " + last_name
	end

	def get_stat_by_week week 
		stats.each do |weekly_stat|
			if weekly_stat.week == week then return week end
		end
	end
end
