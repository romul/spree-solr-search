Solr Search
===========

### Installation

1. Add `gem "spree_solr_search"` to your Gemfile
1. Run `bundle install`
1. Run `rails g spree_solr_search:install`

**NOTE:** Master branch works only with Spree 0.30.x. 
If you want use this extension with Spree 0.10.x or 0.11.x, then you should use spree-0-11-stable branch
    
### Usage

To perform the indexing:

    rake solr:reindex BATCH=500


To start Solr demo-server:

    rake solr:start SOLR_PATH="/home/roman/www/jetty-solr"

To stop Solr demo-server:

    rake solr:stop
    
To configure production Solr server:

    edit RAILS_ROOT/config/solr.yml

P.S. For development recommended use [jetty-solr](http://github.com/dcrec1/jetty-solr) server.


