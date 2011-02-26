begin
  ENV['ONLY'] = "Product"
  SOLR_PATH = ENV['SOLR_PATH']
  RAILS_DEFAULT_LOGGER = Logger.new(Rails.root.join("log", Rails.env + ".log"))
  RAILS_ROOT = Rails.root.to_s unless defined?(RAILS_ROOT)
  require 'acts_as_solr_reloaded'
  load 'tasks/solr.rake'
rescue LoadError
  puts "WARNING: acts_as_solr_reloaded gem appears to be unavailable.  Please install with bundle install."
end
