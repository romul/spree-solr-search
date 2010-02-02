Solr Search
===========

### Installation

1. `script/extension install git://github.com/romul/spree-solr-search.git`
1. Copy `solr_search/config/solr.yml` to `RAILS_ROOT/config/solr.yml`

**NOTE:** This extension works only with Spree 0.9.99 and higher.
    
### Usage

To perform the indexing:

    rake solr:reindex

To start Solr demo-server:

    rake solr:start

To stop Solr demo-server:

    rake solr:stop
    
To configure production Solr server:

    edit RAILS_ROOT/config/solr.yml
