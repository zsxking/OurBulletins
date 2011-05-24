# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                  "Test User"
  user.email                 "testuser@test.edu"
  user.password              "ASdf1234"
  user.password_confirmation "ASdf1234"
end

Factory.define :admin, :class => User do |user|
  user.name                  "Admin User"
  user.email                 "admin@test.edu"
  user.password              "admin1234"
  user.password_confirmation "admin1234"
  user.admin true
end

Factory.sequence :email do |n|
  "person-#{n}@example.edu"
end

Factory.define :post do |post|
  post.title "Factory Post"
  post.category "Products"
  post.description "Post Descriptions"
  post.association :user
end