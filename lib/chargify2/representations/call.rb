module Chargify2
  class Call < Hashie::Dash
    property :id
    property :api_id
    property :timestamp
    property :nonce
    property :success
    property :request
    property :response

    def self.singular_name
      'call'
    end

    def self.plural_name
      'calls'
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

