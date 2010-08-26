Spree::BaseController.class_eval do
  helper :solr
  before_filter :set_searcher
  RAILS_ROOT = Rails.root.to_s
  private
  def set_searcher
    Spree::Config.searcher = Spree::Search::Solr.new    
  end
end
