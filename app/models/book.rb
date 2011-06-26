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
end