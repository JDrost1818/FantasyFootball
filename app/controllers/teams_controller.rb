class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy, :free_agency, :add_player]
  before_action :verify_ownership, only: [:show, :edit, :update, :destroy, :free_agency, :add_player]
  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.all
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
  end

  # GET /teams/1/rem_player/1
  def rem_player
    player = Player.find(params[:player_id])
    @team = Team.find(params[:id])
    player.teams.delete(@team)
    redirect_to :action => "show", :id => params[:id], :tab => "Roster"
  end

  # GET /teams/1/add_player/1
  def add_player
    new_player = Player.find(params[:player_id])
    error = @team.add_player new_player
    if not error then
      redirect_to :action => "free_agency", :tab => new_player.position
    elsif error == 1
      redirect_to :back, alert: "Unable to add #{new_player.full_name}. "\
                                 "Please drop a #{new_player.position} to make room."
    elsif error == 2
      redirect_to :back, alert: "You do not have enough cap space to " \
                                "sign #{new_player.full_name}"
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
    @user = User.find(@team.user_id)
    @team.update_by_hash params[:team]

    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to "/", notice: 'Team was successfully updated.' }
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

    def verify_ownership
      @is_owner = @team.user_id == current_user.id
      # This should eventually be handled differently in 
      # each method. For example, in #show, would be nice
      # to show the user without editing options
      if !@is_owner then 
        redirect_to root_path, alert: "You must own the team to navigate there"
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.permit(:team, :name, :league_id, :player_id, :qb, :rb1, :rb2, :rb3, :wr1, :wr2, :wr3, :te, :k)
    end
end
