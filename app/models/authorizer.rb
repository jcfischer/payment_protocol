# This class can decide if a customer is authorized to perform a transaction
# only a stub that return hard coded values for different customer_ids

class Authorizer

  def self.authorized? customer_id, transaction
    case customer_id
      # customer 1 is always authorized
      when 1 then return true

      # customer 2 is never authorized
      when 2 then return false

      # customer 3 only can spend 10 EUR
      when 3 then
        return transaction.amount <= 10

      # nobody else is authorized
      else
        return false

    end

  end

end