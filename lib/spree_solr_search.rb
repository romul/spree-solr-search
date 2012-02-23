require 'spree_core'

module Spree::SolrSearch
end

module SpreeSolrSearch
  class Engine < Rails::Engine
    initializer "spree.solr_search.preferences", :after => "spree.environment" do |app|
      Spree::SolrSearch::Config = Spree::SolrSearchConfiguration.new
      Spree::Config.searcher_class = Spree::Search::Solr
    end

    def self.activate
      require 'websolr_acts_as_solr'
      ENV['RAILS_ENV'] = Rails.env

      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
      
      # Load application's view overrides
      Dir.glob(File.join(File.dirname(__FILE__), "../app/overrides/**/*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

    end
    config.to_prepare &method(:activate).to_proc
    config.autoload_paths += %W(#{config.root}/lib)
  end
end
