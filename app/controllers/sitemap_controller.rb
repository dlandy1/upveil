class SitemapController < ApplicationController
  layout nil

  def index
    headers['Content-Type'] = 'application/xml'
    last_post = Product.last
    last_cat = Category.last
    last_user = User.last
    if stale?(:etag => last_post, :last_modified => last_post.updated_at.utc)
      respond_to do |format|
        format.xml { @products = Product.all }
      end
    end
       if stale?(:etag => last_cat, :last_modified => last_cat.updated_at.utc)
      respond_to do |format|
        format.xml { @cats = Category.all }
      end
    end
     if stale?(:etag => last_cat, :last_modified => last_cat.updated_at.utc)
      respond_to do |format|
        format.xml { @cats = Category.all }
      end
    end
    if stale?(:etag => last_user, :last_modified => last_user.updated_at.utc)
      respond_to do |format|
        format.xml { @users = User.all }
      end
    end
  end
end