require 'spree_core'
require 'spree_solr_search_hooks'

module SpreeSolrSearch
  class Engine < Rails::Engine
    def self.activate
      require 'websolr_acts_as_solr'
      ENV['RAILS_ENV'] = Rails.env
      
      if Spree::Config.instance
        Spree::Config.searcher_class = Spree::Search::Solr
      end

      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env == "production" ? require(c) : load(c)
      end

    end
    config.to_prepare &method(:activate).to_proc
    config.autoload_paths += %W(#{config.root}/lib)
  end
end
