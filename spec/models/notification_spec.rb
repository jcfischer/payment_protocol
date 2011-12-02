require 'spec_helper'

describe Notification do

  context "#notify" do
    let(:params) {
      {amount: 10.50,
       currency: "EUR",
       reference_number: "ref_1234",
       merchant_id: 1234,
       uuid: "6bab2c5c-62b8-5d02-c891-f163375635bb"}
    }

    let(:transaction) { t = Transaction.new params.to_json; t.pre_commit; t.authorize!; t }

    it "notifies the merchant" do
      Notification.should_receive(:call_merchant_with)
      Notification.notify transaction
    end


  end


end