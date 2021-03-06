# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "spree_solr_search"
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Roman Smirnov"]
  s.date = "2012-12-01"
  s.description = "Provides search via Apache Solr for a Spree store."
  s.email = "roman@railsdog.com"
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    ".gitignore",
     "README.md",
     "Rakefile",
     "VERSION",
     "Versionfile",
     "app/assets/javascripts/store/solr_sort_by.js.coffee",
     "app/helpers/spree/base_helper_decorator.rb",
     "app/models/spree/product_decorator.rb",
     "app/models/spree/solr_search_configuration.rb",
     "app/overrides/show_search_partials.rb",
     "app/views/spree/products/_facets.html.erb",
     "app/views/spree/products/_sort_bar.html.erb",
     "app/views/spree/products/_suggestion.html.erb",
     "config/initializers/solr_config.rb",
     "config/locales/en.yml",
     "config/locales/ru-RU.yml",
     "config/locales/ru.yml",
     "lib/generators/spree_solr_search/install_generator.rb",
     "lib/generators/templates/solr.yml",
     "lib/solr_manager.rb",
     "lib/spree/search/solr.rb",
     "lib/spree_solr_search.rb",
     "lib/tasks/acts_as_solr.rake",
     "lib/websolr_acts_as_solr.rb",
     "spree_solr_search.gemspec"
  ]
  s.homepage = "http://github.com/romul/spree-solr-search"
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Provides search via Apache Solr for a Spree store."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<spree_core>, [">= 1.0.0"])
      s.add_runtime_dependency(%q<acts_as_solr_reloaded>, [">= 1.6.0"])
    else
      s.add_dependency(%q<spree_core>, [">= 1.0.0"])
      s.add_dependency(%q<acts_as_solr_reloaded>, [">= 1.6.0"])
    end
  else
    s.add_dependency(%q<spree_core>, [">= 1.0.0"])
    s.add_dependency(%q<acts_as_solr_reloaded>, [">= 1.6.0"])
  end
end

