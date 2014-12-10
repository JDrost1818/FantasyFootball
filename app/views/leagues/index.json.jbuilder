json.array!(@leagues) do |league|
  json.extract! league, :id, :description, :name, :salary_cap
  json.url league_url(league, format: :json)
end
