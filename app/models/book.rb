class Book < ActiveRecord::Base
  #require 'open-uri'
  require 'amazon/ecs'
  Amazon::Ecs.configure do |options|
        options[:aWS_access_key_id] = 'AKIAJLFSLR3OKNGCPENQ'
        options[:aWS_secret_key] = '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'
  end

  attr_readonly :title, :author, :description, :ean, :isbn,
                  :edition, :publisher, :publish_date, :image_link,
                  :list_price, :amazon_detail_url

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

      review_content = item.get_element('EditorialReviews')
                           .get_element('EditorialReview').get('Content')

      price_string = item.get_element('ListPrice').get('Amount')

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
              :amazon_detail_url => item.get('DetailPageURL'),
              :list_price => price_string.to_f / 100
      }
      new_book = self.new(book_attr)

      books.push(new_book)
    end
    return books
  end
end
