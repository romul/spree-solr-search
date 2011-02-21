require "acts_as_solr"

if ENV["WEBSOLR_URL"]
  require "json"
  require "net/http"
  require "uri"
  
  api_key = ENV["WEBSOLR_URL"][/[0-9a-f]{11}/] or raise "Invalid WEBSOLR_URL: bad or no api key"
  
  ENV["WEBSOLR_CONFIG_HOST"] ||= "www.websolr.com"
  
  @pending = true
  Rails.logger.info "Checking index availability..."

  begin
    schema_url = URI.parse("http://#{ENV["WEBSOLR_CONFIG_HOST"]}/schema/#{api_key}.json")
    response = Net::HTTP.post_form(schema_url, "client" => "acts_as_solr-1.3")
    json = JSON.parse(response.body.to_s)

    case json["status"]
    when "ok"
      Rails.logger.info "Index is available!"
      @pending = false
    when "pending"
      Rails.logger.info "Provisioning index, things may not be working for a few seconds ..."
      sleep 5
    when "error"
      Rails.logger.error json["message"]
      @pending = false
    else
      Rails.logger.error "wtf: #{json.inspect}" 
    end
  rescue Exception => e
    STDERR.puts "Error checking index status. It may or may not be available.\n" +
                "Please email support@onemorecloud.com if this problem persists.\n" +
                "Exception: #{e.message}"
  end
  
  module ActsAsSolr
    class Post        
      def self.execute(request, core = nil)
        begin
          connection = Solr::Connection.new(ENV["WEBSOLR_URL"])
          return connection.send(request)
        rescue Exception => e
          STDERR.puts "Couldn't connect to the Solr server at #{ENV["WEBSOLR_URL"]}. #{$!}\n" +
                      "Request: #{request.inspect}"
          false
        end
      end
    end
  end
end
