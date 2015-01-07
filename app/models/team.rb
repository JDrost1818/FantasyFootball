class Team < ActiveRecord::Base
  belongs_to :league
  belongs_to :user

  has_and_belongs_to_many :players

  has_many :home_games, :foreign_key => 'home_team_id', :class_name => 'Games'
    has_many :away_games, :foreign_key => 'away_team_id', :class_name => 'Games'

  def get_record
    wins = 0; losses = 0; ties = 0;
      games.each do |cur_game|
        if cur_game.week < league.current_week then
          winner == cur_game.get_winner

          if winner == self then wins += 1
          elsif winner.nil? then ties += 1
          else losses += 1
          end  
        end
      end

    return "#{wins}-#{losses}-#{ties}"
  end

  def get_current_game
    return get_game_by_week(self.league.current_week)
  end

  def get_win_loss_message
    cur_game = get_current_game
    team2 = cur_game.get_other_team(self)
    if cur_game.winner? self then
      "You defeated #{team2.name} #{cur_game.get_score_for_one self} - #{cur_game.get_score_for_one team2}!"
    elsif cur_game.winner?(self).nil? then
      "You lost to #{team2.name} #{cur_game.get_score_for_one self} - #{cur_game.get_score_for_one team2}."
    else
      "You Tied #{team2.name} #{cur_game.get_score_for_one self} - #{cur_game.get_score_for_one team2}."
    end
  end

  def games
    Game.where("home_team_id = ? OR away_team_id = ?", self.id, self.id)
  end

  def league
    League.find(self.league_id)
  end

  def user
    User.find(self.user_id)
  end

  def get_game_by_week week
    games.each do |game|
      if game.week == week
        return game
      end
    end
    return nil
  end

  def get_num_matchups other_team
    num_games = 0
    games.each do |game|
      if game.get_other_team(self) == other_team
        num_games = num_games + 1
      end
    end
    return num_games
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
    self.players << player
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

  def get_this_weeks_score
    score = 0
    players.each do |player|
      score += player.get_current_week_stat_for(self)
    end
    return score
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

  def update_by_hash table
    players = get_formatted_player_list

    if players[0].instance_of? Player then players[0].set_this_week_score( table["qb"] , self ) end
    if players[1].instance_of? Player then players[1].set_this_week_score( table["rb1"], self ) end
    if players[2].instance_of? Player then players[2].set_this_week_score( table["rb2"], self ) end
    if players[3].instance_of? Player then players[3].set_this_week_score( table["rb3"], self ) end
    if players[4].instance_of? Player then players[4].set_this_week_score( table["wr1"], self ) end
    if players[5].instance_of? Player then players[5].set_this_week_score( table["wr2"], self ) end
    if players[6].instance_of? Player then players[6].set_this_week_score( table["wr3"], self ) end
    if players[7].instance_of? Player then players[7].set_this_week_score( table["te"],  self ) end
    if players[8].instance_of? Player then players[8].set_this_week_score( table["k"],   self ) end

    get_current_game.update_score_for( self, get_this_weeks_score )
    save
  end

end
