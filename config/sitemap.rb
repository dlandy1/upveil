# Set the host name for URL creation
require 'rubygems'
require 'sitemap_generator'
SitemapGenerator::Sitemap.default_host = "http://www.upveil.com"

# The remote host where your sitemaps will be hosted
 SitemapGenerator::Sitemap.sitemaps_host = "http://s3.amazonaws.com/sitemap-generator/"

 # The directory to write sitemaps to locally
 SitemapGenerator::Sitemap.public_path = 'tmp/'

 # Set this to a directory/path if you don't want to upload to the root of your `sitemaps_host`
 SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

 # Instance of `SitemapGenerator::WaveAdapter`
 SitemapGenerator::Sitemap.adapter = SitemapGenerator::WaveAdapter.new

if Rails.env == "enviornment"
  SitemapGenerator::Sitemap.create do
    Category.find_each do |category|
      add category_path(category), :lastmod => category.updated_at
    end
    Product.find_each do |product|
      add category_product_path(product.category, product), :lastmod => product.updated_at
    end
    User.find_each do |user|
      add user_path(user), :lastmod => user.updated_at
    end
  end
end

SitemapGenerator::Sitemap.ping_search_engines
