class SolrManager
  def initialize(mode, object, auto_commit)
    @mode = mode
    @object = object
    @auto_commit = auto_commit
  end
  
  def perform
    puts "#{@mode}: #{@object.class.name} : #{@object.id}"
    if @mode == "solr_save"
      @object.solr_add(@object.to_solr_doc)
    elsif @mode == "solr_destroy"
      @object.solr_delete(@object.solr_id)
    end
    @object.solr_commit if @auto_commit
  end
end
