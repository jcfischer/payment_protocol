require 'spec_helper'

describe Transaction do

  let(:params) {
    {amount: 10.50,
     currency: "EUR",
     reference_number: "ref_1234",
     merchant_id: 1234,
     signature: "ac72e03ccb6ff1b5d203784f9313e38e",
     uuid: "6bab2c5c-62b8-5d02-c891-f163375635bb"}
  }

  context "#initialize" do
    [:amount, :currency, :reference_number, :merchant_id, :uuid, :signature].each do |attr|
      it "has #{attr} accessor" do
        transaction = Transaction.new params.to_json
        transaction.send(attr.to_sym).should == params[attr]
      end
    end
  end

  context "#valid?" do

    let(:transaction) { Transaction.new params.to_json }

    context "with correct secret" do

      it "raises if no secret was defined" do
        lambda { transaction.valid? }.should raise_error(NoSecretDefined)
      end
      it "checks the signature of the data" do
        transaction.secret = "deadcafe"
        transaction.should be_valid
      end
    end

    context "with wrong secret" do
      it "checks the signature of the data" do
        transaction.secret = "wrong"
        transaction.should_not be_valid
      end
    end
  end

  context "#token" do
    let(:transaction) { Transaction.new params.to_json }

    it "returns a hashed token" do
      transaction.token.should == "c03fd2b9bd74219e53b961ee5d314226"
    end

    it "returns just a few bits of the token" do
      transaction.token(16).should == "c03f"
    end

    it "returns 20  bits of the token" do
      transaction.token(20).should == "c03fd"
    end
  end

  context "#numeric_token" do
    let(:transaction) { Transaction.new params.to_json }

    it "returns a hashed token" do
      transaction.numeric_token(5).should == 49215
    end
  end
end