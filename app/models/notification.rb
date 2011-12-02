# Handles notification of merchant
# only stubbed for demonstration purposes

require 'uuid'

class Notification

  attr_accessor :signature

  def initialize transaction
    @status = transaction.status
    @amount = transaction.amount
    @currency = transaction.currency
    @reference_number = transaction.reference_number
    @transaction_id = transaction.transaction_id
    @token = transaction.num_token
    @merchant_id = transaction.merchant_id
    @uuid = UUID.new.generate

  end

  def as_params
    {:amount => @amount,
     :currency => @currency,
     :merchant_id => @merchant_id,
     :status => @status,
     :transaction_id => @transaction_id,
     :token => @token,
     :reference_number => @reference_number,
     :uuid => @uuid}
  end

  def self.call_merchant_with notification
    puts "Calling Merchant with the following data"
    puts notification.as_params
    puts "Signature: #{notification.signature}"
  end

  def self.notify transaction
    notification = Notification.new transaction
    notification.signature =  Signum.signature_for :value => notification.as_params , :secret => monk_settings(:secret)
    call_merchant_with notification
  end
end