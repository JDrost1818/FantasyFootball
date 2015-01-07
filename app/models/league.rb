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
    num_teams = self.teams.length
    part_teams = self.teams.each_slice(num_teams/2).to_a

    # Think of this as two circles of teams, with the inner
    # circle being the second half of teams. They will rotate
    # one space each week until all of the games are scheduled
    (1..16).each do |week|
      (0...part_teams[0].length).each do |team|
        # Simply creates varying home/away matchups
        home_away_key = rand(2)
        away_team = part_teams[home_away_key][team]
        home_team = part_teams[1 - home_away_key][team]

        new_game = Game.create!(:away_team => away_team,
                                :home_team => home_team,
                                :week => week)
        away_team.games << new_game
        home_team.games << new_game
      end
      # rotates inner circle of teams
      last_team = part_teams[1].pop
      part_teams[1].insert(0, last_team)
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
