class LeaguesController < ApplicationController
  before_action :set_league, only: [:show, :edit, :update, :destroy, :addteam, :close, :advance_week]

  # GET /leagues
  # GET /leagues.json
  def index
    @leagues = League.all
  end

  # GET /leagues/1
  # GET /leagues/1.json
  def show
  end

  def close

    if @league.teams.length == 0 then
      @league.delete
      redirect_to League, alert: "League deleted because it contained no teams"
    elsif @league.teams.length % 2 != 0 then
      redirect_to :back, alert: "League must have an even number of teams"
    else
       @league.close_registration
      team = @league.find_team_by current_user
      if team.nil? then redirect_to "/"
      else redirect_to team_url(team) end
    end
  end

  def advance_week

    #
    #
    # This take entirely too long. I wish that I could
    # get Sidekiq to work... (Really happens in League.advance_week method)
    #
    #
    #

    @league.advance_week
    @team = Team.where("user_id = ? AND league_id = ?", current_user.id, @league.id)[0]
    flash[:notice] = "Thank you for waiting"
    redirect_to :action => "show", :id => @team.id, :controller => "teams"
  end

  # GET /leagues/new
  def new
    @league = League.new
  end

  # GET /leagues/1/edit
  def edit
  end

  def addteam
  end

  # POST /leagues
  # POST /leagues.json
  def create
    @league = League.new(league_params)
    @league.league_owner_id = current_user.id

    respond_to do |format|
      if @league.save
        format.html { redirect_to :action => "addteam", :id => @league.id }
        format.json { render :show, status: :created, location: @league.addteam }
        format.js   { }
      else
        format.html { render :new }
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /leagues/1
  # PATCH/PUT /leagues/1.json
  def update
    @user_team = Team.where("league_id = ?", @league.id)[0]
    respond_to do |format|
      if @league.update(league_params)
        format.html { redirect_to team_path(@user_team.id), notice: 'League was successfully updated.' }
        format.json { render :show, status: :ok, location: @league }
      else
        format.html { render :edit }
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leagues/1
  # DELETE /leagues/1.json
  def destroy
    destroy_object @league
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_league
      @league = League.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def league_params
      params.require(:league).permit(:name, :salary_cap, :description, :id)
    end
end
