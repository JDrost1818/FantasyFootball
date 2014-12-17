class LeaguesController < ApplicationController
  before_action :set_league, only: [:show, :edit, :update, :destroy, :addteam, :close]

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
    respond_to do |format|
      if @league.update(league_params)
        format.html { redirect_to @league, notice: 'League was successfully updated.' }
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
    @league.destroy
    respond_to do |format|
      format.html { redirect_to leagues_url, notice: 'League was successfully destroyed.' }
      format.json { head :no_content }
    end
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
