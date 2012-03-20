Spree::BaseHelper.module_eval do
  def link_to_facet(name, value, count) 
      facets_hash = params[:facets]
      facets_hash = {} unless facets_hash.is_a?(Hash)
      facets_hash = facets_hash.merge({name => ["\"#{value}\"", facets_hash[name]].join(',')})
      request.params.delete(:page)
      link_to("#{value} (#{count})", url_for(request.params.merge({:facets => facets_hash})))
  end

  # hate to clutter up the BaseHelper with this one-time
  def sort_by_options_list
  	# generate <options></options> list
  	options = ::PRODUCT_SORT_FIELDS.map { |k, v| [t(k), url_for(request.params.merge({:sort => k}))] }
  	options_for_select(options, url_for(request.params.merge({ :sort => params[:sort] || ::PRODUCT_SORT_FIELDS.keys.first })))
  end
end
