# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                  "Shaoxuan Test"
  user.email                 "shaoxuan@hawaii.edu"
  user.password              "ASdf1234"
  user.password_confirmation "ASdf1234"
end