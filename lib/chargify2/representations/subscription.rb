module Chargify2
  class Subscription < Hashie::Dash
    property :id
    property :customer
    property :customer_id
    property :product
    property :state
    property :previous_state
    property :expires_at
    property :trial_started_at
    property :trial_ended_at
    property :current_period_started_at
    property :current_period_ends_at
    property :next_assessment_at
    property :cancellation_message
    property :activated_at
    property :canceled_at
    property :delayed_cancel_at
    property :coupon_code
    property :signup_payment_id
    property :credit_card
    property :signup_revenue
    property :balance_in_cents
    property :created_at
    property :updated_at
    property :success
    property :url
    property :request
    property :response
    property :errors

    def self.singular_name
      'subscription'
    end

    def self.plural_name
      'subscriptions'
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

    class Request < OpenCascade; end
    class Response < OpenCascade; end
  end
end

