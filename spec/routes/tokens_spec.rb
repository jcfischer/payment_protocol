require 'spec_helper'

describe 'REQUEST Phase of protocol' do
  include Rack::Test::Methods


  context "POST /tokens" do

    def do_post
      UuidPool.instance.clear # clear the UuidPool for test purposes
      header 'Content-Type', 'application/json'
      post "/tokens", {:transaction => {:amount => 10.50, :currency => "EUR",
                                        :reference_number => "ref_1234",
                                        :merchant_id => 1234,
                                        :signature => "ac72e03ccb6ff1b5d203784f9313e38e",
                                        :uuid => "6bab2c5c-62b8-5d02-c891-f163375635bb"}}.to_json
      JSON.parse(last_response.body)
    end


    context "valid token" do

      it "returns http 201" do
        do_post
        last_response.status.should == 201
      end

      it "returns a numeric token" do
        response = do_post
        response['token'].should == 51024
      end

      it "returns a transaction id " do
        response = do_post
        response['transaction_id'].should == "c7501f73b0e7dfcb1495d7c60829f447"
      end

      it "stores the transaction" do
        TransactionStore.instance.should_receive(:store)
        do_post
      end
    end

    context "invalid signature" do
      def do_post
        header 'Content-Type', 'application/json'
        post "/tokens", {:transaction => {:amount => 10.50, :currency => "EUR",
                                          :reference_number => "ref_1234",
                                          :merchant_id => 1234,
                                          :signature => "a3562b14ae3b14cc6db2aa0wrong",
                                          :uuid => "6bab2c5c-62b8-5d02-c891-f163375635bb"}}.to_json
      end

      it "returns 403 - Forbidden" do
        do_post
        last_response.status.should == 403
      end
    end

    context "replay" do
      def do_post
        header 'Content-Type', 'application/json'
        post "/tokens", {:transaction => {:amount => 10.50, :currency => "EUR",
                                          :reference_number => "ref_1234",
                                          :merchant_id => 1234,
                                          :signature => "ac72e03ccb6ff1b5d203784f9313e38e",
                                          :uuid => "6bab2c5c-62b8-5d02-c891-f163375635bb"}}.to_json
      end

      it "returns 409 - Conflict" do
        do_post
        do_post
        last_response.status.should == 409
      end
    end
  end


end
