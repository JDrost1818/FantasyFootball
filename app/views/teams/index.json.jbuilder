json.array!(@teams) do |team|
  json.extract! team, :id, :name, :total_salary
  json.url team_url(team, format: :json)
end
