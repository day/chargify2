require 'spec_helper'

module Chargify2
  describe SubscriptionResource do
    it "should have a URI of 'https://api.chargify.com/api/v2/subscriptions'" do
      SubscriptionResource.uri.should == 'https://api.chargify.com/api/v2/subscriptions'
    end

    it "represents with the Subscription class" do
      SubscriptionResource.representation.should == Subscription
    end

    describe "creating a Subscription" do
      it "should return false" do
        WebMock.stub_request(:post, /https?:\/\/api.chargify.com\/api\/v2\/subscriptions\??(.*)/).to_return(:body => '{"subscription":{}}', :status => 501)
        SubscriptionResource.create({:foo => 'bar'}).should be_false
      end

      # it "should return a status code of '501 Not Implemented'" do
      #   WebMock.stub_request(:post, /https?:\/\/api.chargify.com\/api\/v2\/subscriptions\??(.*)/).to_return(:status => 501)
      #   SubscriptionResource.create({:foo => 'bar'}).status.should == '501 Not Implemented'
      # end
    end

    describe "updating a Subscription" do
      it "should return false" do
        WebMock.stub_request(:put, /https?:\/\/api.chargify.com\/api\/v2\/subscriptions\??(.*)/).to_return(:status => 501)
        SubscriptionResource.update(123, {:foo => 'bar'}).should be_false
      end

      # it "should return a status code of '501 Not Implemented'" do
      #   WebMock.stub_request(:put, /https?:\/\/api.chargify.com\/api\/v2\/subscriptions\??(.*)/).to_return(:body => "", :status => 501)
      #   SubscriptionResource.update(123, {:foo => 'bar'}).status.should == '501 Not Implemented'
      # end
    end

    describe "reading a Subscription resource" do
      it "performs a GET request to 'https://api.chargify.com/api/v2/subscriptions/123' (without authentication) when called with '123'" do
        WebMock.stub_request(:get, 'https://api.chargify.com/api/v2/subscriptions/123').to_return(:body => '{"subscription":{}}', :status => 200)
        SubscriptionResource.read('123')
        a_request(:get, 'https://api.chargify.com/api/v2/subscriptions/123').should have_been_made.once
      end

      it "returns a Subscription representation" do
        WebMock.stub_request(:get, 'https://api.chargify.com/api/v2/subscriptions/123').to_return(:body => '{"subscription":{}}', :status => 200)
        SubscriptionResource.read('123').should be_a(Subscription)
      end

      it "returns nil when the status is not 200" do
        WebMock.stub_request(:get, 'https://api.chargify.com/api/v2/subscriptions/123').to_return(:status => 404)
        SubscriptionResource.read('123').should be_nil
      end
    end

    describe "retrieving a list of Subscription resources" do
      it "performs a GET request to 'https://api.chargify.com/api/v2/subscriptions' (without authentication) when called with '123'" do
        WebMock.stub_request(:get, 'https://api.chargify.com/api/v2/subscriptions').to_return(:body => '{"subscriptions":{}}', :status => 200)
        SubscriptionResource.list
        a_request(:get, 'https://api.chargify.com/api/v2/subscriptions').should have_been_made.once
      end

      it "returns an array of Subscription representations" do
        WebMock.stub_request(:get, 'https://api.chargify.com/api/v2/subscriptions').to_return(:body => '{"subscriptions":{}}', :status => 200)
        SubscriptionResource.list.should be_a(Array)
      end

      it "returns an empty array when no subscriptions are found" do
        WebMock.stub_request(:get, 'https://api.chargify.com/api/v2/subscriptions').to_return(:body => '{"subscriptions":{}}', :status => 404)
        SubscriptionResource.list.should  == []
      end
    end

    context "instance configured with a client and a non-standard base URI" do
      it "has a URI of 'http://www.example.com/subscriptions'" do
        base_uri = 'http://www.example.com'
        client = Client.new(valid_client_credentials.merge(:base_uri => base_uri))
        SubscriptionResource.new(client).uri.should == 'http://www.example.com/subscriptions'
      end
    end

    context "instance configured with a valid client" do
      before(:each) do
        @client = Client.new(valid_client_credentials)
        @subscription_resource = SubscriptionResource.new(@client)
      end

      it "performs a GET request to 'https://<api_login>:<api_password>@api.chargify.com/api/v2/subscriptions/123' (with authentication) when called with '123'" do
        WebMock.stub_request(:get, "https://#{@client.api_id}:#{@client.api_password}@api.chargify.com/api/v2/subscriptions/123").to_return(:body => '{"subscription":{}}', :status => 200)

        SubscriptionResource.read('123')
        a_request(:get, "https://#{@client.api_id}:#{@client.api_password}@api.chargify.com/api/v2/subscriptions/123").should have_been_made.once
      end

      it "returns a Subscription representation" do
        WebMock.stub_request(:get, "https://#{@client.api_id}:#{@client.api_password}@api.chargify.com/api/v2/subscriptions/123").to_return(:body => '{"subscription":{}}', :status => 200)
        SubscriptionResource.read('123').should be_a(Subscription)
      end
    end
  end
end