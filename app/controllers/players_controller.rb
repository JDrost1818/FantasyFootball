class PlayersController < ApplicationController
  before_action :set_player, only: [:show, :edit, :update, :destroy]

  # GET /players
  # GET /players.json
  def index
    @players = Player.all
  end

  # GET leagues/1/players/1
  def show
    if params[:team_id] then
      @league = Team.find(params[:team_id]).league
      @stats = @player.get_stats_for_league(@league.id)
    else
      redirect_to :back, alert: 'Must view a player while viewing a team'
    end
  end

  # GET /players/new
  def new
    @player = Player.new
  end

  # GET /players/1/edit
  def edit
  end

  # POST /players
  # POST /players.json
  def create
    @player = Player.new(player_params)
    handle_post_creation @player
  end

  # PATCH/PUT /players/1
  # PATCH/PUT /players/1.json
  def update
    update_object @player, player_params
  end

  # DELETE /players/1
  # DELETE /players/1.json
  def destroy
    destroy_object @player
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def player_params
      params.require(:player).permit(:first_name, :last_name, :position, :salary, :team_id)
    end
end
