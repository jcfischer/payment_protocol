require 'signum'

class NoSecretDefined < RuntimeError; end

class Transaction

  attr_accessor :amount, :currency, :merchant_id, :reference_number, :uuid, :signature, :secret

  def initialize params
    params = JSON.parse(params) unless params.class == Hash
    @amount = params['amount']
    @currency = params['currency']
    @merchant_id = params['merchant_id']
    @reference_number = params['reference_number']
    @uuid = params['uuid']
    @signature = params['signature']
  end

  def as_params
    {:amount => @amount,
     :currency => @currency,
     :merchant_id => @merchant_id,
     :reference_number => @reference_number,
     :uuid => @uuid}
  end

  # checks to see if the passed signature is equal to the computed signature
  # given a secret
  def valid?
    raise NoSecretDefined unless @secret
    signed = Signum.signature_for(:value => self.as_params, :secret => @secret)
    signed.signature == @signature
  end

  # returns a token with the length of n bits (where n is a multiple of 4)
  def token(n = 128)
    hash = Signum.signature_for(:value => self.as_params, :secret => "salted-#{@secret}").signature
    hex_digits = (n / 4)  -1  # computes the number of chars n bits are represented in
    hash[0..hex_digits]
  end

  # returns a decimal number with n digits
  def numeric_token(n = 6)
    bits = (n * 3.31)
    token = self.token(bits)
    token.to_i(16)
  end
end