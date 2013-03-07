require 'net/http'

module Rovi

  class Api
    include HTTParty

    disable_rails_query_string_format
    format :json
    base_uri "http://api.rovicorp.com"
    default_params format: 'json', country: 'US', language: 'en'

    def initialize(api_key, api_secret)
      @api_key, @api_secret = api_key, api_secret
      @version = "v1"
      @service_name = "data"
    end

    def get(category, method, params = {})
      params.merge!(required_params)
      options = self.class.default_options.dup.merge!({
        query: params
      })

      path = build_path(category, method)
      request = Request.new(Net::HTTP::Get, path, options )

      response = self.class.get(path, options)
      response.parsed_response
    end

    private

    def build_path(category, method)
      ["", @service_name, @version, category, method].join("/")
    end

    def required_params
      { :apikey => @api_key, :sig => generate_sig }
    end

    def generate_sig
      Digest::MD5.hexdigest(@api_key + @api_secret + Time.now.to_i.to_s)
    end

  end

end
