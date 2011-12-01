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
                    status 200
          else
            status 402
          end
        when :expired then
          status 410
        when :authorized then
          status 409
      end

    else
      status 404
    end
  end
end