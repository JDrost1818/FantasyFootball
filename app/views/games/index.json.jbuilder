json.array!(@games) do |game|
  json.extract! game, :id, :week
  json.url game_url(game, format: :json)
end
