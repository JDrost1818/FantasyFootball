# create a admin test user for logging in
u = User.create!(email: "admin@gmail.com", first_name: "Admin", last_name: "User", password: "qwerty1234")
u.is_admin = true
u.save

# create a regular test user for logging in
u = User.create!(email: "test@gmail.com", first_name: "Test", last_name: "User", password: "123123123")
u.is_admin = false
u.save
