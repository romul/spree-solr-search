module Spree::Search
  class Solr < defined?(Spree::Core::Search::MultiDomain) ? Spree::Core::Search::MultiDomain :  Spree::Core::Search::Base
    protected

    def get_products_conditions_for(base_scope, query)
      facets = {
          :fields => PRODUCT_SOLR_FACETS,
          :browse => @properties[:facets_hash].map{|k,v| "#{k}:#{v}"},
          :zeros => false 
      }

      search_options = {:facets => facets, :limit => 25000, :lazy => true}

      # if order_by_price
      #   search_options.merge!(:order => (order_by_price == 'descend') ? "price desc" : "price asc")
      # end

      if not @properties[:sort].nil? and PRODUCT_SORT_FIELDS.has_key? @properties[:sort]
        sort_option = ::PRODUCT_SORT_FIELDS[@properties[:sort]]
        base_scope = base_scope.order("#{sort_option[0]} #{sort_option[1].upcase}")
      end

      full_query = query + " AND is_active:(true)"
      if taxon 
        taxons_query = taxon.self_and_descendants.map{|t| "taxon_ids:(#{t.id})"}.join(" OR ")
        full_query += " AND (#{taxons_query})"
      end
      
      full_query += " AND store_ids:(#{current_store_id})" if current_store_id

      result = Spree::Product.find_by_solr(full_query, search_options)

      products = result.records

      @properties[:products] = products
      @properties[:suggest] = nil
      begin
        if suggest = result.suggest
          suggest.sub!(/\sAND.*/, '')
          @properties[:suggest] = suggest if suggest != query
        end
      rescue

      end

      @properties[:facets] = parse_facets_hash(result.facets)
      base_scope.where(["spree_products.id IN (?)", products.map(&:id)])
      # base_scope.order("spree_products.name DESC")
    end

    def prepare(params)
      super
      @properties[:facets_hash] = params[:facets] || {}
      @properties[:manage_pagination] = false
      @properties[:sort] = params[:sort] || nil
      # @properties[:order_by_price] = params[:order_by_price]
    end
    
    private
    
    def parse_facets_hash(facets_hash = {"facet_fields" => {}})
      facets = []
      facets_hash["facet_fields"].each do |name, options|
        options = Hash[*options.flatten] if options.is_a?(Array)
        next if options.size <= 1
        facet = Facet.new(name.sub('_facet', ''))
        options.each do |value, count|
          facet.options << FacetOption.new(value, count, facet.name)
        end
        facets << facet
      end
      facets
    end
  end
  
  
  class Facet
    attr_accessor :options
    attr_accessor :name
    def initialize(name, options = [])
      self.name = name
      self.options = options
    end
  end
  
  class FacetOption
    attr_accessor :name
    attr_accessor :count
    attr_accessor :facet_name
    def initialize(name, count, facet_name)
      self.name = name
      self.count = count
      self.facet_name = facet_name
    end    
  end
end
