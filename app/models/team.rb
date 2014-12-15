class Team < ActiveRecord::Base
	belongs_to :league
	belongs_to :user
	has_and_belongs_to_many :players

	NUM_QBS = 1
	NUM_RBS = 3
	NUM_WRS = 3
	NUM_TES = 1
	NUM_KS  = 1

	def get_record
	    "16-0"
	end

	def get_cap_space_disp
		(get_cap_space / 1000).to_s + "k"
	end

	def get_cap_space
		cap_used = 0
		players.each do |player|
			cap_used = cap_used + player.salary
		end
		League.find(league_id).salary_cap - cap_used
	end

	def get_formatted_player_list
		players = []

		qbs = get_players_by_pos "QB"
		rbs = get_players_by_pos "RB"
		wrs = get_players_by_pos "WR"
		tes = get_players_by_pos "TE"
		ks  = get_players_by_pos "K"

		# Adds the QB if present else "QB"
		players[0] = qbs.length == 0 ? "QB" : qbs[0]

		# Adds the RBs if present else "RB" 
		(1..3).each do |num|
			players[num] = rbs.length < num ? "RB" : rbs[num-1]
		end

		# Adds the WRs if present else "WR"
		(4..6).each do |num|
			players[num] = wrs.length < num-3 ? "WR" : wrs[num-4]
		end

		# Adds the TE if present else "TE"
		players[7] = tes.length == 0 ? "TE" : tes[0]

		# Adds the K if present else "K"
		players[8] = ks.length == 0 ? "K" : ks[0]

		return players
	end

	def add_player player
		players_at_pos = get_players_by_pos(player.position).length

		# Returns error if no room at new player's position
		if player.position == "WR" or player.position == "RB" then
			if players_at_pos >= 3 then
				return 1
			end
		elsif players_at_pos >= 1 then
			return 1
		end

		# Returns error if not enough cap space to sign player
		if player.salary > get_cap_space then
			return 2
		end

		# No errors, add player
		players << player
		return nil
	end

	def positions
      ["QB", "RB", "WR", "TE", "K"]
    end

	def get_players_by_pos pos
		player_list = []
		players.each do |player|
			if player.position == pos then
				player_list.push(player)
			end
		end
		return player_list
	end

    def free_agency_desc_by_pos pos 
    	player_list = get_players_by_pos pos
    	if pos == "RB" or pos == "WR" then
    		return_string = "Current #{pos}s: "
    		3.times do |num|
    			return_string += player_list[num].nil? ? "#{num+1} - None " : "#{num+1} - #{player_list[num].full_name} " 
    		end
    	else
    		player_name = player_list[0].nil? ? "None" : player_list[0].full_name
    		return "Current #{pos}: #{player_name}"
    	end
    	return return_string
    end
end
