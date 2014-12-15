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

	def add_player player
		players_at_pos = get_players_by_pos(player.position).length
		if player.position == "WR" or player.position == "RB" then
			if players_at_pos >= 3 then
				return false
			end
		elsif players_at_pos >= 1 then
			return false
		end
		players << player
		return true
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

    def get_fa_players_by_pos pos
    	teams_in_cur_league = []
	    League.find(league_id).teams.each do |team|
	      teams_in_cur_league.push(team)
	    end

	    @player_list = []
	    @all_players = Player.all
	    @all_players.each do |p|
	      if (teams_in_cur_league & p.teams).empty? and p.position == pos then
	        @player_list.push(p)
	      end
	    end
	    return @player_list
    end

    def free_agency_desc_by_pos pos 
    	player_list = get_players_by_pos pos
    	if pos == "RB" or pos == "WR" then
    		return_string = "Current #{pos}s: "
    		(1..3).each do |num|
    			return_string += player_list[num].nil? ? "(#{num}) None " : "(#{num}) #{player_list[num].full_name} " 
    		end
    	else
    		player_name = player_list[0].nil? ? "None" : player_list[0].full_name
    		return "Current #{pos}: #{player_name}"
    	end
    	return return_string
    end
end
