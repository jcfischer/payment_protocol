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
        transaction = Transaction.new params
        transaction.send(attr).should == params[attr]
      end
    end
  end

  context "#valid?" do

    let(:transaction) { Transaction.new params }

    it "raises if no secret was defined" do
      lambda { transaction.valid? }.should raise_error(NoSecretDefined)
    end
    it "checks the signature of the data" do
      transaction.secret = "deadcafe"
      transaction.should be_valid
    end
  end

end