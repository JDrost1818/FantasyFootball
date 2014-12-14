class PlayersTeamsController < ApplicationController
  before_action :set_players_team, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @players_teams = PlayersTeam.all
    respond_with(@players_teams)
  end

  def show
    respond_with(@players_team)
  end

  def new
    @players_team = PlayersTeam.new
    respond_with(@players_team)
  end

  def edit
  end

  def create
    @players_team = PlayersTeam.new(players_team_params)
    @players_team.save
    respond_with(@players_team)
  end

  def update
    @players_team.update(players_team_params)
    respond_with(@players_team)
  end

  def destroy
    @players_team.destroy
    respond_with(@players_team)
  end

  private
    def set_players_team
      @players_team = PlayersTeam.find(params[:id])
    end

    def players_team_params
      params[:players_team]
    end
end
