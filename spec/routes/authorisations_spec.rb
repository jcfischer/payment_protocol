require 'spec_helper'

describe 'AUTHORIZE Phase of protocol' do
  include Rack::Test::Methods

  let(:params) {
    {amount: 10.50,
     currency: "EUR",
     reference_number: "ref_1234",
     merchant_id: 1234,
     signature: "ac72e03ccb6ff1b5d203784f9313e38e",
     uuid: "6bab2c5c-62b8-5d02-c891-f163375635bb"}
  }
  let(:transaction) { Transaction.new params.to_json }

  context "authorize known & good token" do
    def do_put
      header 'Content-Type', 'application/json'
      put '/authorisation/c03fd2b9bd74219e53b961ee5d314226', {:customer_id => 1}.to_json
    end

    before(:each) do
      transaction.save
    end

    it "returns 200 - OK" do
      do_put
      last_response.status.should == 200
    end
  end

  context "customer not authorised" do
    def do_put
      header 'Content-Type', 'application/json'
      put '/authorisation/c03fd2b9bd74219e53b961ee5d314226', {:customer_id => 2}.to_json
    end

    before(:each) do
      transaction.save
    end

    it "returns 402 - Payment Required" do
      do_put
      last_response.status.should == 402
    end
  end

  context "customer not authorised - amount too large" do
    def do_put
      header 'Content-Type', 'application/json'
      put '/authorisation/c03fd2b9bd74219e53b961ee5d314226', {:customer_id => 3}.to_json
    end

    before(:each) do
      transaction.save
    end

    it "returns 402 - Payment Required" do
      do_put
      last_response.status.should == 402
    end
  end

  context "token not found" do
    def do_put
      header 'Content-Type', 'application/json'
      put '/authorisation/unknown', {:customer_id => 1}.to_json
    end

    it "returns 404 - Not Found" do
      do_put
      last_response.status.should == 404
    end
  end

  context "transaction already used" do
    def do_put
      header 'Content-Type', 'application/json'
      put '/authorisation/c03fd2b9bd74219e53b961ee5d314226', {:customer_id => 1}.to_json
    end

    before(:each) do
      transaction.save
    end

    it "returns 409 - Conflict" do
      do_put
      do_put
      last_response.status.should == 409
    end
  end

  context "token expired" do
    def do_put
      header 'Content-Type', 'application/json'
      put '/authorisation/c03fd2b9bd74219e53b961ee5d314226', {:customer_id => 1}.to_json
    end

    before(:each) do
      transaction.expire!
      transaction.save
    end

    it "returns 410 - Gone" do
      do_put
      last_response.status.should == 410
    end
  end
end
