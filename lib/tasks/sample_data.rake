
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

    books_isbn = [9781933988658, 9780061353246, 9780262033848, 9780596007737,
                  9781111399115, 9780716771593, 9780321694508, 9780521697675,
                  9780132136839, 9780393931129]
    books = Array.new
    books_isbn.each do |isbn|
      new_book = Book::get_from_amazon_by_isbn(isbn)[0]
      new_book.save
      books.push new_book
    end

    sale_words = ['', 'Sale', 'Sell', 'WTS', 'Selling']

    User.all(:limit => 6).each do |user|
      (5 + rand(10)).times do
        new_listing = user.listings.build(
                :title=>Faker::Lorem.sentence(1 + rand(10)),
                :price => rand(5000),
                :description => Faker::Lorem.paragraph(1 + rand(5)))
        if (rand(5) >= 1)
          book = books.sample
          new_listing.saleable = book
          new_listing.title = sale_words.sample + ' ' + book.title
          new_listing.price = book.list_price * rand(70) / 100
        end
        new_listing.save
      end
    end

  end
end