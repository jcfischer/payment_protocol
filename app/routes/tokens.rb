class Main

  # accepts a JSON reques
  post '/tokens' do
    params = JSON.parse(request.body.read.to_s)

    transaction = Transaction.new params['transaction']
    transaction.secret = monk_settings(:secret)

    content_type "application/json"
    if transaction.valid?
      if UuidPool.instance.seen?(transaction.uuid)
        status 409
        {:error => "Request already seen by server"}.to_json
      else
        UuidPool.instance.add(transaction.uuid)
        transaction.pre_commit
        transaction.save
        status 201
        {:token => transaction.numeric_token(5),
         :transaction_id => transaction.token }.to_json
      end
    else
      status 403
      {:error => 'Signature does not match'}.to_json
    end
  end
end