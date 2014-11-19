page.insert_html :bottom, :products, :partial => @products
if @products.total_pages > @products.current_page
  page.call 'checkScroll'
else
  page[:loading].hide
end