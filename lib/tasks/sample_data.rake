
namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    #Rake::Task['db:reset'].invoke
    admin = User.create!(:name => "Admin User",
                 :email => "admin@university.edu",
                 :password => "foobar123",
                 :password_confirmation => "foobar123")
    admin.toggle!(:admin)
    admin.status= UserStatus::ACTIVE
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@university.edu"
      password  = "password1234"
      user = User.create!(:name => name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
      user.status= UserStatus::ACTIVE
    end
  end
end