# By Henrik Nyh <http://henrik.nyh.se> 2007-06-15.
# Free to modify and redistribute with credit.

# Adds a find_all_by_solr method to acts_as_solr models to enable 
# will_paginate for acts_as_solr search results.

module ActsAsSolr
  module PaginationExtension

    def find_all_by_solr(query, options)
      find_by_solr(query, options).records
    end

  end
end

module ActsAsSolr::ClassMethods
  include ActsAsSolr::PaginationExtension
end
