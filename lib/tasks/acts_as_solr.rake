begin
  ENV['ONLY'] = "Product"
  SOLR_PATH = ENV['SOLR_PATH']
  #require "acts_as_solr/tasks"
  Gem.path.each do |gem_path|
    Dir["#{gem_path}/gems/acts_as_solr_reloaded-1.4.0/lib/tasks/*.rake"].sort.each { |ext| load ext }
  end
rescue LoadError
  puts "WARNING: acts_as_solr_reloaded gem appears to be unavailable.  Please install with rake gems:install."
end
