Deface::Override.new(:virtual_path => "spree/shared/_taxonomies",
                      :name => "show_search_partials_facets",
                      :insert_top => "#taxonomies",
                      :partial => "spree/products/facets",
                      :disabled => false)
                     
Deface::Override.new(:virtual_path => "spree/products/index",
                      :name => "show_search_partials_suggestion",
                      :insert_top => "[data-hook='search_results']",
                      :partial => "spree/products/suggestion",
                      :disabled => false)

Deface::Override.new(:virtual_path => "spree/shared/_products",
                      :name => "override_paginated_products_var",
                      :insert_top => "h6.search-results-title",
                      :text => "<% paginated_products = @searcher.products %>",
                      :disabled => false)
