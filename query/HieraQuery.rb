#
# This class can be used in a fact to query the hieralookup
# service. 
#
require 'net/http'
require 'uri'
require 'json'
require 'logger'

class HieraQuery

  @@user = nil
  @@pass = nil
  @@use_ssl = false
  @@logger = Logger.new(STDOUT)
  @@logger.level = Logger::ERROR
  
  def self.rest(uri_str, limit = 10)
    raise ArgumentError, 'Too many HTTP redirects' if limit == 0
    uri = URI(uri_str)
    @@logger.info("Query request_uri -> #{uri.request_uri}")
    @@logger.debug("Query host -> #{uri.host}")
    @@logger.debug("Query port -> #{uri.port}")
    
    http = Net::HTTP.new(uri.host, uri.port)
    begin
      if @@use_ssl or uri_str.start_with? 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      request = Net::HTTP::Get.new uri.request_uri
      unless (@@user.nil? or @@pass.nil?)
        request.basic_auth(@@user, @@pass)
      end
      http.request request do |response|
        case response
        when Net::HTTPRedirection then
          redirect = response['location']
          @@logger.error("redirected to #{redirect}")
          rest(redirect, limit - 1)
        when Net::HTTPForbidden then
          raise SecurityError, 'Access denied'
        when Net::HTTPNotFound then
          raise ArgumentError, 'Not found'
        when Net::HTTPSuccess then
          begin
            json = response.read_body
            @@logger.debug("Query response -> #{json}")
            @@logger.debug("Query response class -> #{json.class}")
            result = JSON.parse(json)
            @@logger.debug("Query result -> #{result}")
            @@logger.debug("Query result class -> #{result.class}")
            return result
          end
        else
          raise "Unexpected state => #{response.code} - #{response.message}"
        end
      end
    rescue Net::HTTPError => e
      raise e
    ensure
      if nil != http and http.started?
        http.finish()
      end
    end
  end

  def self.query(uri_str)
    @@logger.debug("Query uri string -> #{uri_str}")
    for retries in 1..3
      begin
        return rest(uri_str)
      rescue SecurityError => s
        @@logger.error("SecurityError -> \n#{s.inspect}")
        break
      rescue ArgumentError => a
        @@logger.error("ArgumentError -> \n#{a.inspect}")
        break
      rescue IOError => eio
        @@logger.warn("IO Exception during http request -> \n#{eio.inspect}")
      rescue Net::HTTPError => ehttp
        @@logger.warn("HTTP Exception during http request -> \n#{ehttp.inspect}")
      rescue StandardError => e
        @@logger.warn("Exception during http request -> \n#{e.inspect}")
        break
      end
      sleep(5)
    end
  end

end