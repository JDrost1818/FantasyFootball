class League < ActiveRecord::Base
	has_many :teams, dependent: :destroy
	accepts_nested_attributes_for :teams, :allow_destroy => true

	validates_length_of :name, :minimum => 5, :maximum => 20, :allow_blank => false

	def close_registration
		self.is_open_for_registration = false
		set_schedule
		self.save
	end

	def advance_week
		self.teams.each do |team|
			UserMailer.weekly_email(team).deliver
			team.get_current_game.close
		end
		self.current_week += 1
		self.save
	end

	def set_schedule
		self.teams.each do |team1|
			max_matchups = 1
			(1..16).each do |week|
				if team1.get_game_by_week(week).nil? then
					self.teams.each do |team2|
						if team1 != team2 and
							team2.get_game_by_week(week).nil? and
							team1.get_num_matchups(team2) < max_matchups then

							away_team = (rand(2) == 1) ? team1 : team2
							home_team = (team1 == away_team) ? team2 : team1

							new_game = Game.create!(:away_team => away_team, 
										 			:home_team => home_team, 
										 			:week => week)
							team1.games << new_game
							team2.games << new_game
							team1.save
							team2.save
							break
						end
					end
				end
				if ((week % (self.teams.length-1)) == 0) then max_matchups += 1 end
			end
		end
	end

	def find_team_by user
		teams.each do |team|
			if team.user_id == user.id then return team end
		end
		return nil
	end

	def get_current_week
		current_week
	end

	def get_salary_cap
		(salary_cap / 1000).to_s + "k"
	end

	def get_fa_by_pos pos 
		player_list = []
		Player.all.each do |p|
	      if (teams.to_a & p.teams).empty? and p.position == pos then
	        player_list.push(p)
	      end
	    end
	    return player_list
	end

	def get_all_fa 
		qb = []; rb = []; wr = []; te = []; k = [];
		Player.all.each do |p|
	      if (teams.to_a & p.teams).empty? then
	      	if 	  p.position == "QB" then qb.push p
	        elsif p.position == "RB" then rb.push p
	        elsif p.position == "WR" then wr.push p
	        elsif p.position == "TE" then te.push p
	        elsif p.position == "K"  then k.push p  end	
	      end
	    end
	    return qb, rb, wr, te, k
	end
end
