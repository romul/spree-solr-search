require 'spree_core'
require 'spree_solr_search_hooks'

module SpreeSolrSearch
  class Engine < Rails::Engine
    def self.activate
      require 'acts_as_solr'
      ENV['RAILS_ENV'] = Rails.env
      Spree::Config.searcher_class = Spree::Search::Solr
      Spree::Config.set(:product_price_ranges => 
           ["Under $25", "$25 to $50", "$50 to $100", "$100 to $200", "$200 and above"])

      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env == "production" ? require(c) : load(c)
      end
    end
    config.to_prepare &method(:activate).to_proc
    config.autoload_paths += %W(#{config.root}/lib)
  end
end
