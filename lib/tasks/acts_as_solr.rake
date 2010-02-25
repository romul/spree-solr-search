begin
  ENV['ONLY'] = "Product"
  SOLR_PATH = ENV['SOLR_PATH']
  require 'acts_as_solr_reloaded'
  load 'tasks/solr.rake'
rescue LoadError
  puts "WARNING: acts_as_solr_reloaded gem appears to be unavailable.  Please install with rake gems:install."
end
