# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class SolrSearchExtension < Spree::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/solr_search"

  # Please use solr_search/config/routes.rb instead for extension routes.

  def self.require_gems(config)
    config.gem "acts_as_solr_reloaded", :version => '>=1.3.0'
  end
  
  def activate
    require 'acts_as_solr'
    require 'solr_pagination'

    Spree::Config.set(:product_price_ranges => 
                      ["Under $25", "$25 to $50", "$50 to $100", "$100 to $200", "$200 and above"])
    
    Product.class_eval do
      acts_as_solr  :fields => [:name, :description, :is_active, {:price => :float}, 
                                :taxon_ids, :price_range, :taxon_names,
                                :brand_option, :color_option, :size_option],
                    :facets=>[:price_range, :taxon_names,
                              :brand_option, :color_option, :size_option]

      def taxon_ids
        taxons.map(&:id)
      end
      
      def is_active
        !deleted_at && 
          (available_on <= Time.zone.now) && 
            (Spree::Config[:allow_backorders] || count_on_hand > 0)
      end
      
      private
      
      def taxon_names
        taxons.map(&:name)
      end
      
      def price_range
        price_ranges = Spree::Config[:product_price_ranges]
        case price
          when 0..25
            price_ranges[0]
          when 25..50
            price_ranges[1]
          when 50..100
            price_ranges[2]
          when 100..200
            price_ranges[3]
          else
            price_ranges[4]
        end
      end
      
      def brand_option
        get_option_values('brand')
      end

      def color_option
        get_option_values('color')
      end

      def size_option
        get_option_values('size')
      end
      
      def get_option_values(option_name)
        option = options.detect{|option| option.option_type.name == option_name}
        return [] if option.nil? 
        values = variants.map{|v| v.option_values.select{|ov| ov.option_type_id == option.option_type_id}.map(&:presentation) }
        values.flatten.uniq      
      end
    end
    
    Spree::BaseController.class_eval do
      helper :solr
    end
    
    Spree::Config.searcher = Spree::Search::Solr.new
  end
end
