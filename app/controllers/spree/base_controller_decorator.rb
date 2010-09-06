Spree::BaseController.class_eval do
  helper :solr
  RAILS_ROOT = Rails.root.to_s
end
