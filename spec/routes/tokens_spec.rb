require 'spec_helper'

describe 'tokens API' do
  include Rack::Test::Methods

  context "REQUEST Phase of protocol" do
    context "POST /tokens" do

      def do_post
        post "/tokens", {:transaction => {amount: 10.50, currency: "EUR",
                         reference_number: "ref_1234",
                         merchant_id: 1234,
                         signature: "a3562b14ae3b14cc6db2aa01840273f4",
                         uuid: "6bab2c5c-62b8-5d02-c891-f163375635bb"}}.to_json
      end


      context "request new token" do

        it "returns http 201" do
          do_post
          last_response.status.should == 201
        end

        it "check the signature" do

        end
      end
    end
  end
end
