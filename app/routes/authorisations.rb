class Main

  put '/authorisation/:token' do
    s = request.body.read
    param = JSON.parse(s)
    customer_id = param['customer_id']
    transaction = Transaction.find params[:token]
    if transaction
      case transaction.status
        when :new then
          if Authorizer.authorized? customer_id, transaction
            transaction.authorize!
            transaction.save
            Notification.notify transaction
            status 200
            { status: "authorized", transaction_id: transaction.transaction_id}.to_json
          else
            transaction.reject!
            Notification.notify transaction
            status 402
            { error: "Transaction not authorized by server", transaction_id: transaction.transaction_id}.to_json
          end
        when :expired then
          Notification.notify transaction
          status 410
          { error: "Transaction already expired", transaction_id: transaction.transaction_id}.to_json
        when :authorized then
          status 409
          { error: "Transaction was already authorized", transaction_id: transaction.transaction_id}.to_json
      end

    else
      status 404
    end
  end
end