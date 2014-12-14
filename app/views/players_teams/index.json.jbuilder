json.array!(@players_teams) do |players_team|
  json.extract! players_team, :id
  json.url players_team_url(players_team, format: :json)
end
