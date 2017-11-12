require 'open-uri'

class PageParse
  attr_accessor :doc
  ADDRESS_ELEMENT_SELECTOR = '.listing .address a'
  NEXT_PAGE_SELECTOR = "[title='Go to next page']"

  def initialize(url)
    @doc = Nokogiri::HTML(open(url))
  end

  def next_page_url
    next_page_node = doc.css(NEXT_PAGE_SELECTOR)
    next_page_node.present? ? next_page_node.first.attr(:href) : nil
  end

  def select_addresses
    doc.css(ADDRESS_ELEMENT_SELECTOR).map do |address_node|
      address_node.attr(:title).split(',').first
    end
  end
end