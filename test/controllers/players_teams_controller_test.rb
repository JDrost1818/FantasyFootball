require 'test_helper'

class PlayersTeamsControllerTest < ActionController::TestCase
  setup do
    @players_team = players_teams(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:players_teams)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create players_team" do
    assert_difference('PlayersTeam.count') do
      post :create, players_team: {  }
    end

    assert_redirected_to players_team_path(assigns(:players_team))
  end

  test "should show players_team" do
    get :show, id: @players_team
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @players_team
    assert_response :success
  end

  test "should update players_team" do
    patch :update, id: @players_team, players_team: {  }
    assert_redirected_to players_team_path(assigns(:players_team))
  end

  test "should destroy players_team" do
    assert_difference('PlayersTeam.count', -1) do
      delete :destroy, id: @players_team
    end

    assert_redirected_to players_teams_path
  end
end
