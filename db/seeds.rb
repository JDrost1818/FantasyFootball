# create a admin test user for logging in
u1 = User.create!(email: "admin@gmail.com", first_name: "Admin", last_name: "User", password: "qwerty1234")
u1.is_admin = true
u1.save

# create a regular test user for logging in
u2 = User.create!(email: "test@gmail.com", first_name: "Test", last_name: "User", password: "123123123")
u2.is_admin = false
u2.save

l1 = League.create!(name: "Test League 1", salary_cap: 50000, description: "This is a seeded league that is used for testing purposes where Admin User is the owner")
l1.league_owner_id = u1.id 
l1.save

l2= League.create!(name: "Test League 2", salary_cap: 50000, description: "This is a seeded league that is used for testing purposes where Test User is the owner")
l2.league_owner_id = u2.id 
l2.save

# Creates Admin's teams
t1 = Team.create!(name: "Show Me Yo TDs")
u1.teams << t1
u1.save

l1.teams << t1
l1.save