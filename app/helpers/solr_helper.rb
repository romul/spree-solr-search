module SolrHelper
  def link_to_facet(name, value, count) 
      facets_hash = params[:facets]
      facets_hash = {} unless facets_hash.is_a?(Hash)
      facets_hash = facets_hash.merge({name => ["\"#{value}\"", facets_hash[name]].join(',')})
      link_to("#{value} (#{count})", :overwrite_params => params.merge({:facets => facets_hash}))
  end
end
