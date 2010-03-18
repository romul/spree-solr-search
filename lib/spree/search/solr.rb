module Spree::Search
  class Solr < Spree::Search::Base
    # method should return hash with conditions {:conditions=> "..."} for Product model
    def get_products_conditions_for(query)
      facets = {
          :fields => [:price_range, :taxon_names, :brand_property, :color_option, :size_option],
          :browse => @properties[:facets_hash].map{|k,v| "#{k}:#{v}"},
          :zeros => false 
      }
      search_options = {:facets => facets, :limit => 25000, :lazy => true}
      if order_by_price
        search_options.merge!(:order => (order_by_price == 'descend') ? "price desc" : "price asc")
      end
      full_query = query + " AND is_active:(true)"
      if taxon 
        taxons_query = taxon.self_and_descendants.map{|t| "taxon_ids:(#{t.id})"}.join(" OR ")
        full_query += " AND (#{taxons_query})"
      end

      result = Product.find_by_solr(full_query, search_options)
      @properties[:products] = result.records
      count = result.records.size

      products = Product.paginate_all_by_solr(query,
                  :page => page, :per_page => per_page, :total_entries => count)

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
    
    private
    
    def parse_facets_hash(facets_hash = {"facet_fields" => {}})
      facets = []
      price_ranges = YAML::load(Spree::Config[:product_price_ranges])
      facets_hash["facet_fields"].each do |name, options|
        next if options.size <= 1
        facet = Facet.new(name.sub('_facet', ''))
        if name == 'price_range_facet'
          price_ranges.each do |price_range|           
            count = options[price_range]
            facet.options << FacetOption.new(price_range, count) if count
          end
        else
          options.each do |value, count|
            facet.options << FacetOption.new(value, count)
          end
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
    def initialize(name, count)
      self.name = name
      self.count = count
    end    
  end
end
