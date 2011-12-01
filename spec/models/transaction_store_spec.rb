require 'spec_helper'


describe TransactionStore do

  let(:params) {{amount: 10.50,
         currency: "EUR",
         reference_number: "ref_1234",
         merchant_id: 1234,
         signature: "ac72e03ccb6ff1b5d203784f9313e38e",
         uuid: "6bab2c5c-62b8-5d02-c891-f163375635bb"}
  }
  let(:store) { TransactionStore.instance }
  let(:transaction) { Transaction.new params.to_json }
  it "stores a transaction" do
    token = transaction.token
    store.store token, transaction

    t = store.get token
    t.should == transaction
  end
end