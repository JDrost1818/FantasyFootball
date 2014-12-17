class Game < ActiveRecord::Base
	belongs_to :away_team, :foreign_key => 'away_team_id', :class_name => "Team"
	belongs_to :home_team, :foreign_key => 'home_team_id', :class_name => "Team"

	def winner? team
		(team == away_team) ? away_score > home_score : home_team_score > away_team_score
	end

	def get_score_for_one team
		(team == home_team) ? home_score : away_score
	end

	def get_other_team team1
		team1 == away_team ? home_team : away_team
	end

	def get_game_display team
		if team == home_team then return "#{home_team.name} vs #{away_team.name}"
		else return "#{away_team.name} @ #{home_team.name}" end
	end

	def to_s
		"#{home_team.name} vs #{away_team.name}"
	end

	def get_at_or_vs team
		(team == home_team) ? "vs" : "@"
	end

	def get_cur_user_team user
		if home_team.user_id == user.id then
			return home_team 
		elsif away_team.user_id == user.id then
			return away_team
		else
			return nil
		end
	end	
end
