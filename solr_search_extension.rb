# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class SolrSearchExtension < Spree::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/solr_search"

  # Please use solr_search/config/routes.rb instead for extension routes.

  def self.require_gems(config)
    config.gem "acts_as_solr_reloaded", :version => '1.2.0'
  end
  
  def activate
    require 'acts_as_solr'
    require 'solr_pagination'

    Product.class_eval do
      acts_as_solr :fields => [:name, :description]
    end
    
    Spree::Config.searcher = Spree::Search::Solr.new
  end
end
