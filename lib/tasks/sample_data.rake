
namespace :db do
  desc "Fill database with sample data"
  namespace :populate do

    task :books => :environment do
      require 'csv'
      books_isbn = Array.new
      # Get isbn from csv list
      CSV.foreach("lib/isbn_list.csv", :skip_blanks => true) do |row|
        # use row here...
        next if (row[0] == nil)
        books_isbn.push(row[0].to_s)
      end
      # shuffle and clean up the list
      books_isbn = books_isbn.uniq.shuffle
      Book.find_all_by_ean(books_isbn).each do |exist_book|
        books_isbn.delete(exist_book.ean)
      end
      # add books
      books_isbn.each do |isbn|
        new_book = Book::get_from_amazon_by_isbn(isbn)
        next if new_book.nil?
        new_book.save
      end
    end

    task :listings => :environment do
      User.all(:limit => 6).each do |user|
        (10 + rand(10)).times do
          new_listing = user.listings.build(
                  :title=>Faker::Lorem.sentence(1 + rand(10)),
                  :price => rand(5000)/100.0,
                  :description => Faker::Lorem.paragraph(1 + rand(5)))
          book_count = Book.count()
          if (rand(5) >= 1)
            book = Book.first(:offset =>rand(book_count))
            new_listing.saleable = book
            new_listing.title = nil
            base_price = book.list_price ? book.list_price : 10.0
            new_listing.price = base_price * (rand(60) + 20) / 100.0 + 1
          end
          new_listing.save
        end
      end
    end

    task :users => :environment do
      #admin = User.create!(:name => "Admin User",
      #             :email => "admin@university.edu",
      #             :password => "foobar123",
      #             :password_confirmation => "foobar123")
      #admin.toggle!(:admin)
      #admin.status= UserStatus::ACTIVE
      99.times do |n|
        name  = Faker::Name.name
        email = "example-#{n+1}@university.edu"
        password  = "password1234"
        user = User.create!(:name => name,
                     :email => email,
                     :password => password,
                     :password_confirmation => password)
        user.confirmed_at = Time.new
      end

    end
  end
end