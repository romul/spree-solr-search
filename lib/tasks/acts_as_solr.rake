begin
  ENV['ONLY'] ||= "Product"
  SOLR_PATH = ENV['SOLR_PATH']
  RAILS_DEFAULT_LOGGER = Logger.new(Rails.root.join("log", Rails.env + ".log"))
  RAILS_ROOT = Rails.root.to_s unless defined?(RAILS_ROOT)
  require 'acts_as_solr_reloaded'
  load 'tasks/solr.rake'
rescue LoadError
  puts "WARNING: acts_as_solr_reloaded gem appears to be unavailable.  Please install with bundle install."
end

namespace :solr do
  task :optimize => :environment do
    acts_as_solr_lib_path = $LOAD_PATH.find{|path| path =~ /acts_as_solr_reloaded/ }
    require File.expand_path("#{acts_as_solr_lib_path}/../config/solr_environment")
    begin
      puts "Optimizing..."
      Product.solr_optimize
    rescue Errno::ECONNREFUSED
      puts "Can't run optimizing, b/c Solr server is unavailable."
    end
  end
end

