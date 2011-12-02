


## Testing the protocol server

Open two command line shells. Start the protocol server in one:

    $ ruby init.rb


### REQUEST Phase

In the other, issue the following commands (playing the merchant, that requests a new transaction to take place)

    echo '{"transaction":{"amount":10.5,"currency":"EUR","reference_number":"ref_1234","merchant_id":1234,"signature":"ac72e03ccb6ff1b5d203784f9313e38e","uuid":"6bab2c5c-62b8-5d02-c891-f163375635bb"}}' | curl -X POST -H "Content-type: application/json" -d @- http://localhost:4567/tokens

You should receive the following response:

    {"token":51024,"transaction_id":"c7501f73b0e7dfcb1495d7c60829f447"}

If you issue the request a second time, you will get an error message:

    {"error":"Request already seen by server"}

### AUTHORIZE Phase

To confirm the transaction, issue the following command (now playing the customer):

    echo '{"customer_id": 1}' | curl -X PUT -H "Content-type: application/json" -d @- http://localhost:4567/authorisation/c7501f73b0e7dfcb1495d7c60829f447

You should see the servers confirmation:

    {"status":"authorized","transaction_id":"c7501f73b0e7dfcb1495d7c60829f447"}

If you try to redo the authorizsation, you will see the following error:

    {"error":"Transaction was already authorized","transaction_id":"c7501f73b0e7dfcb1495d7c60829f447"}


If you try to authorize the transaction with customer_id = 2, you will receive the following error:

    {"error":"Transaction not authorized by server","transaction_id":"c7501f73b0e7dfcb1495d7c60829f447"}

### NOTIFICATION Phase

Finally, in terminal 1, you will see the dummy notification that would be sent to the merchant:

    Calling Merchant with the following data
    {:amount=>10.5, :currency=>"EUR", :merchant_id=>1234, :status=>:authorized, :transaction_id=>"c7501f73b0e7dfcb1495d7c60829f447", :token=>51024, :reference_number=>"ref_1234", :uuid=>"016bdf50-feb3-012e-0751-60f84734f770"}
    Signature: 3fecb488945e89dd60ba9047faefe274