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
    res = Amazon::Ecs.item_search(isbn, {:response_group => 'Medium'})
    if (res.total_results <= 0)
      return nil
    end
    books = Array.new
    res.items.each do |item|
      item_attributes = item.get_element('ItemAttributes')

      medium_image_uri = item.get_element('MediumImage').get('URL')
      #medium_image_uri.read

      small_image_uri = item.get_element('SmallImage').get('URL')

      review_content = item.get_element('EditorialReviews').get_element('EditorialReview').get('Content')

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
              :image_link => medium_image_uri,
              :icon_link => small_image_uri,
              :amazon_detail_url => item.get('DetailPageURL'),
              :list_price => price
      }
      new_book = self.new(book_attr)

      books.push(new_book)
    end
    return books
  end

  def lowest_price
    self.listings.minimum :price
  end
end
