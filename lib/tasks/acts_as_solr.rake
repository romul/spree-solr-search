begin
  require "acts_as_solr/tasks"
rescue LoadError
  puts "WARNING: acts_as_solr_reloaded gem appears to be unavailable.  Please install with rake gems:install."
end
