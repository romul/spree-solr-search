unless defined?(PRODUCT_PRICE_RANGES)
  PRODUCT_PRICE_RANGES = {0..25 => "  Under $25", 25..50 => " $25 to $50", 
                          50..100 => " $50 to $100", 100..200 => "$100 to $200"}
end
unless defined?(PRODUCT_SOLR_FIELDS)
  PRODUCT_SOLR_FIELDS = [:name, :description, :is_active, {:price => :float}, 
                        :taxon_ids, :price_range, :taxon_names, :store_ids,
                        :brand_property, :color_option, :size_option]
end
unless defined?(PRODUCT_SOLR_FACETS)
  PRODUCT_SOLR_FACETS = [:price_range, :taxon_names,
                        :brand_property, :color_option, :size_option]
end
