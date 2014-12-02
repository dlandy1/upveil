# Set the host name for URL creation
require 'rubygems'
require 'sitemap_generator'
SitemapGenerator::Sitemap.default_host = "http://www.upveil.com"

SitemapGenerator::Sitemap.create do
  Category.find_each do |category|
    add category_path(category), :lastmod => category.updated_at
  end
  Product.find_each do |product|
    add category_product_path(product.category, product), :lastmod => product.updated_at
  end
end
SitemapGenerator::Sitemap.ping_search_engines
