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

    Product.class_eval do
      acts_as_solr  :fields => [:name, :description, :is_active, {:price => :float}, 
                                :taxon_ids, :price_range, :taxon_names],
                    :facets=>[:price_range, :taxon_names]


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
        case price
          when 0..15
            "Under $15"
          when 15..20
            "$15 to $20"
          when 20..100
            "$20 to $100"
          when 100..200
            "$100 to $200"
          else
            "$200 & Above"
        end
      end
      
    end
    
    Spree::Config.searcher = Spree::Search::Solr.new
  end
end
