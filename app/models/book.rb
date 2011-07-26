class Book < ActiveRecord::Base
  #require 'open-uri'
  require 'amazon/ecs'
  Amazon::Ecs.configure do |options|
        options[:aWS_access_key_id] = 'AKIAJLFSLR3OKNGCPENQ'
        options[:aWS_secret_key] = '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'
  end

  attr_readonly :title, :author, :description, :ean, :isbn,
                  :edition, :publisher, :publish_date, :image_link,
                  :icon_link, :list_price, :amazon_detail_url

  has_many :listings, :as => :saleable

  # just include the Tanker module
  include Tanker

  # define the callbacks to update or delete the index
  # these methods can be called whenever or wherever
  # this varies between ORMs
  after_save :update_tank_indexes
  after_destroy :delete_tank_indexes

  # define the index by supplying the index name and the fields to index
  # this is the index name you create in the Index Tank dashboard
  # you can use the same index for various models Tanker can handle
  # indexing searching on different models with a single Index Tank index
  tankit OurBulletins::Application.config.tanker_index do
    indexes :title
    indexes :author
    indexes :description
    indexes :isbn
    indexes :ean
    indexes :publisher
    #indexes :tag_list #NOTICE this is an array of Tags! Awesome!
    #indexes :category, :category => true # make attributes also be categories (facets)

    # you may also dynamically retrieve field data
    indexes :listing_count do
      listings.size
    end

    # you cal also dynamically set categories
    #category :content_length do
    #  content.length
    #end

  end


  def self.get_from_amazon_by_isbn(isbn)
    #@res = Amazon::Ecs.item_search(params[:amazon][:keywords], :type => 'Keywords', :search_index => 'Books')
    # Amazon-ecs gem has these default:
    #   search index : Books
    #   search type : keywords
    res = Amazon::Ecs.item_lookup(isbn, :response_group => 'Medium',
                                  :idType => 'ISBN', :SearchIndex => 'Books')
    if (res.items.size <= 0)
      return nil
    end
    item = res.items[0]
    return self.make_from_amazon(item)
  end

  def self.grab_books_amazon(keywords)
    res = Amazon::Ecs.item_search(keywords, :response_group => 'Medium',
                                  :search_index => 'Books')
    if (res.total_results <= 0)
      return nil
    end
    books = Array.new
    res.items.each do |item|
      new_book = self.make_from_amazon(item)
      books.push(new_book)
    end
    return books
  end

  def self.make_from_amazon(item)
    item_attributes = item.get_element('ItemAttributes')

    review_content = item.get('EditorialReviews/EditorialReview/Content') || ''

    price_ele = item.get_element('ListPrice')
    price = price_ele ? price_ele.get('Amount').to_f / 100.0 : nil

    book_attr = {
            :title => item_attributes.get('Title'),
            :author => item_attributes.get('Author'),
            :ean => item_attributes.get('EAN'),
            :isbn => item_attributes.get('ISBN'),
            :edition => item_attributes.get('Edition'),
            :publisher => item_attributes.get('Publisher'),
            :publish_date => item_attributes.get('PublicationDate'),
            :description => review_content,
            :image_link => item.get('MediumImage/URL') || '',
            :icon_link => item.get('SmallImage/URL') || '',
            :amazon_detail_url => item.get('DetailPageURL'),
            :list_price => price
    }
    return self.new(book_attr)
  end

  def lowest_price
    self.listings.minimum :price
  end

  private

    def update_tank_indexes
      super.update_tank_indexes unless ENV["RAILS_ENV"] == 'test'
    end

    def delete_tank_indexes
      super.delete_tank_indexes unless ENV["RAILS_ENV"] == 'test'
    end
end
