# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                  {Factory.next(:name)}
  user.email                 {Factory.next(:email)}
  user.password              "ASdf1234"
  user.password_confirmation "ASdf1234"
  user.after_create do |u|
    u.confirm!
  end
end

#Factory.define :admin, :class => User do |user|
#  user.name                  "Admin User"
#  user.email                 "admin@test.edu"
#  user.password              "admin1234"
#  user.password_confirmation "admin1234"
#  user.admin true
#end

Factory.sequence :email do |n|
  "person-#{n}@example.edu"
end

Factory.sequence :name do |n|
  "#{n}Test User#{n}"
end

Factory.define :listing do |listing|
  listing.title "Factory Listing"
  listing.price 12.34
  listing.description "Listing Descriptions"
  listing.condition "Like New"
  listing.association :user
end

Factory.define :book do |book|
  book.title 'Factory Book'
  book.author 'An. Author'
  book.isbn '1234567890'
  book.ean '1234567890123'
  book.publish_date '2011-01-11'
  book.publisher 'Factory Publications'
  book.edition '1'
  book.list_price 99.99
  book.image_link '#'
  book.icon_link '#'
end
