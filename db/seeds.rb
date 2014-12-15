# create a admin test user for logging in
u1 = User.create!(email: "admin@gmail.com", first_name: "Admin", last_name: "User", password: "qwerty1234")
u1.is_admin = true
u1.save

l1 = League.create!(name: "Test League 1", salary_cap: 50000, description: "This is a seeded league that is used for testing purposes where Admin User is the owner")
l1.league_owner_id = u1.id 
l1.save

l2= League.create!(name: "Test League 2", salary_cap: 50000, description: "This is a seeded league that is used for testing purposes where Test User is the owner")
l2.league_owner_id = 2
l2.save


users = [ ["test1@gmail.com", "Jake", "Drost", "Show Me Yo TDs"],
		  ["test2@gmail.com", "Michael", "Scott", "Dunder Mifflin"],
		  ["test3@gmail.com", "Peter", "Parker", "Web Slingers"],
		  ["test4@gmail.com", "Stewie", "Griffen", "League Domination"],
		  ["test5@gmail.com", "Clark", "Kent", "Super Team"],
		  ["test6@gmail.com", "Marie", "Antoinette", "Cake Eaters"],
		  ["test7@gmail.com", "Brian", "Williams", "#1 Team On Cable"],
		  ["test8@gmail.com", "Kanye", "West", "Me Myself and I's"]]

users.each do |cur_entry|
	u = User.create!(email: cur_entry[0],
					 first_name: cur_entry[1],
					 last_name: cur_entry[2],
					 password: "123123123")

	t = Team.create!(name: cur_entry[3])
	
	u.teams << t
	l2.teams << t

	u.save
	t.save
	l2.save
end

File.open("Players.csv").each_line do |player|
	info = player.split(",")
	if info[4] == "\r\n" then info[4] = 5000 end
	p = Player.create!(first_name: 	info[0],
					   last_name: 	info[1], 
					   position: 	info[2], 
					   nfl_team: 	info[3],
					   salary: 		info[4])
end