class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy, :free_agency, :add_player]

  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.all
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
  end

  def free_agency
  end

  def add_player
    # Check if we have that position filled
      # if it is filled, ask if they want to replace a player
      # if it isn't filled, add the player
    did_add = @team.add_player Player.find(params[:player_id])
    if did_add then
      redirect_to :back
    else
      # Should prompt the user and say
      # You need to drop a #{pos} before you can add
      # #{player.name}
      redirect_to :back
    end
  end
  
  # GET /teams/new
  def new
    @league = League.find(params[:league_id])
    @team = Team.new(team_params)
    current_user.teams << @team
    @league.teams << @team

    respond_to do |format|
      if @team.save
        format.html { redirect_to :back }
        format.json { render :show, status: :created, location: @team }
        format.js {render inline: "location.reload();" }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  # POST /teams.json
  def create
    @league = League.find(params[:league_id])
    @team = Team.new(team_params)
    current_user.teams << @team
    @league.teams << @team

    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @team }
        format.js {render inline: "location.reload();" }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.permit(:team, :name, :league_id, :player_id)
    end
end
