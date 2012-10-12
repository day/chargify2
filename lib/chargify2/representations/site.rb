module Chargify2
  class Site < Hashie::Dash
    property :id
    property :test_mode
    property :currency
    property :seller_id
    property :configured_gateway
    property :name
    property :subdomain
    property :success
    property :url
    property :request
    property :response

    def self.singular_name
      'site'
    end

    def self.plural_name
      'sites'
    end

    def request
      Request.new(self[:request].deep_symbolize_keys || {})
    end

    def response
      Response.new(self[:response].deep_symbolize_keys || {})
    end

    def successful?
      response.result.status_code.to_s == '200'
    end

    def errors
      (response.result.errors || []).map! {|e| OpenCascade.new(e.deep_symbolize_keys)}
    end

    class Request < Hashery::OpenCascade; end
    class Response < Hashery::OpenCascade; end
  end
end

