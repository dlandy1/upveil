if Rails.env == "development"
   AlgoliaSearch.configuration = { application_id: "KFIEIP3I48", api_key: ENV["ALGO"], pagination_backend: :kaminari }
else
  AlgoliaSearch.configuration = { application_id: "4ISPEJF56E", api_key: ENV["ALGOLIA"], pagination_backend: :kaminari }
end