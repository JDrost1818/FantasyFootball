class Player < ActiveRecord::Base
  has_many :stats
  has_and_belongs_to_many :teams

  def full_name
    first_name + " " + last_name
  end

  def average_points
    total = 0
    self.stats.each do |stat|
      total += stat.points
    end
    return total / self.stats.length
  end

  def get_stat_by_week week, team
    self.stats.each do |weekly_stat|
      if weekly_stat.week == week and weekly_stat.for_league_id == team.league_id then
        return weekly_stat
      end
    end
    # So there wasn't a stat, make it
    stat = Stat.create!(:week => week, :for_league_id => team.league_id )
    self.stats << stat
    self.save
    return stat
  end

  def get_current_week_stat_for team
    stat = get_stat_by_week(team.league.current_week, team)
    if stat.points.nil? then 0 else stat.points end
  end

  def set_this_week_score new_score, team
    stat = get_stat_by_week(team.league.current_week, team)
    stat.points = new_score
    stat.save
  end

  def get_stats_for_league league_id
    Stat.where("for_league_id = ? AND player_id = ?", league_id, self.id)
  end
end
