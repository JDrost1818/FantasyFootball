class Player < ActiveRecord::Base
	has_many :stats
	has_and_belongs_to_many :teams

	def full_name
		first_name + " " + last_name
	end

	def get_stat_by_week week, team
		stats.each do |weekly_stat|
			if weekly_stat.week == week and weekly_stat.for_league_id == team.league_id then
				return weekly_stat.points
			end
		end
		# So there wasn't a stat, make it
		stats << Stat.create!(:week => week, :for_league_id => team.league_id )
		save
		return stats.points
	end

	def get_current_week_stat_for team
		get_stat_by_week(team.league.current_week, team)
	end
end
