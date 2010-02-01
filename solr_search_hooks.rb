class SolrSearchHooks < Spree::ThemeSupport::HookListener

  insert_before :search_results, 'products/facets'
  
end
