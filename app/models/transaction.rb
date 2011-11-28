require 'signum'

class NoSecretDefined < RuntimeError; end

class Transaction

  attr_accessor :amount, :currency, :merchant_id, :reference_number, :uuid, :signature, :secret

  def initialize params
    @amount = params[:amount]
    @currency = params[:currency]
    @merchant_id = params[:merchant_id]
    @reference_number = params[:reference_number]
    @uuid = params[:uuid]
    @signature = params[:signature]
  end

  def as_params
    {:amount => @amount,
     :currency => @currency,
     :merchant_id => @merchant_id,
     :reference_number => @reference_number,
     :uuid => @uuid}
  end

  def valid?
    raise NoSecretDefined unless @secret
    signed = Signum.signature_for(:value => self.as_params, :secret => @secret)
    puts signed
    signed.signature == @signature
  end
end