Spree::BaseHelper.module_eval do
  def link_to_facet(name, value, count) 
      facets_hash = params[:facets]
      facets_hash = {} unless facets_hash.is_a?(Hash)
      facets_hash = facets_hash.merge({name => ["\"#{value}\"", facets_hash[name]].join(',')})
      request.params.delete(:page)
      link_to("#{value} (#{count})", url_for(request.params.merge({:facets => facets_hash})))
  end
end
