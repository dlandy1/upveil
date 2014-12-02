namespace :sites do

  desc "Delete items after 7 days"
  task update: :environment do
     Item.where("created_at <= ?", Time.now - 7.days).destroy_all
  end