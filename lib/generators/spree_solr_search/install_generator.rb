module SpreeSolrSearch
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Configures your Rails application for use with spree_solr_search."

      def copy_config
        template "solr.yml", "config/solr.yml"
      end

      # def show_readme
      #   readme "README" if behavior == :invoke
      # end
    end
  end
end
