module Spree::Search
  class Solr < Spree::Search::Base
    # method should return hash with conditions {:conditions=> "..."} for Product model
    def get_products_conditions_for(query)
      facets = {
          :fields => [:price_range, :taxon_names],
          :browse => @properties[:facets_hash].map{|k,v| "#{k}:#{v}"}  
      }
      search_options = {:facets => facets}
      if order_by_price
        search_options.merge!(:order => (order_by_price == 'descend') ? "price desc" : "price asc")
      end
      query += " AND is_active:(true)"
      if taxon 
        taxons_query = taxon.self_and_descendants.map{|t| "taxon_ids:(#{t.id})"}.join(" OR ")
        query += " AND (#{taxons_query})"
      end

      result = Product.find_by_solr(query, search_options)
      @properties[:products] = result.records
      count = result.records.size

      products = Product.paginate_all_by_solr(query,
                  :page => page, :per_page => per_page, :total_entries => count)

      @properties[:products] = products

      @properties[:facets] = result.facets
      {:conditions=> ["products.id IN (?)", products.map(&:id)]}
    end

    def prepare(params)
      @properties[:facets_hash] = params[:facets] || {}
      @properties[:taxon] = params[:taxon].blank? ? nil : Taxon.find(params[:taxon])
      @properties[:per_page] = params[:per_page]
      @properties[:page] = params[:page]
      @properties[:manage_pagination] = true
      @properties[:order_by_price] = params[:order_by_price]
    end
  end
end
