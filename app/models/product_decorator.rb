Product.class_eval do
  acts_as_solr :fields => PRODUCT_SOLR_FIELDS, :facets => PRODUCT_SOLR_FACETS

  def taxon_ids
    taxons.map(&:id)
  end
  
  def is_active
    !deleted_at && available_on && 
      (available_on <= Time.zone.now) && 
        (Spree::Config[:allow_backorders] || count_on_hand > 0)
  end
  
  # saves product to the Solr index
  def solr_save
    return true if indexing_disabled?
    if evaluate_condition(:if, self)
      if defined? Delayed::Job 
        Delayed::Job.enqueue SolrManager.new("solr_save", self, configuration[:auto_commit])
      else  
        debug "solr_save: #{self.class.name} : #{record_id(self)}"
        solr_add to_solr_doc
        solr_commit if configuration[:auto_commit]        
      end
      true
    else
      solr_destroy
    end
  end

  private
  
  def store_ids
    if self.respond_to? :stores
      stores.map(&:id)
    else
      []
    end
  end
  
  def taxon_names
    taxons.map(&:name)
  end
  
  def price_range
    max = 0
    PRODUCT_PRICE_RANGES.each do |range, name|
      return name if range.include?(price)
      max = range.max if range.max > max
    end
    I18n.t(:price_and_above, :price => max)
  end
  
  def brand_property
    pp = ProductProperty.first(:joins => :property, 
          :conditions => {:product_id => self.id, :properties => {:name => 'brand'}})
    pp ? pp.value : ''
  end

  def color_option
    get_option_values('color')
  end

  def size_option
    get_option_values('size')
  end
  
  def get_option_values(option_name)
    sql = <<-eos
      SELECT DISTINCT ov.id, ov.presentation
      FROM option_values AS ov
      LEFT JOIN option_types AS ot ON (ov.option_type_id = ot.id)
      LEFT JOIN option_values_variants AS ovv ON (ovv.option_value_id = ov.id)
      LEFT JOIN variants AS v ON (ovv.variant_id = v.id)
      LEFT JOIN products AS p ON (v.product_id = p.id)
      WHERE (ot.name = '#{option_name}' AND p.id = #{self.id});
    eos
    OptionValue.find_by_sql(sql).map(&:presentation)     
  end
end
