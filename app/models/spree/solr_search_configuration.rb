class Spree::SolrSearchConfiguration < Spree::Preferences::Configuration
  preference :auto_commit, :boolean, :default => true
end
