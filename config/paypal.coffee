AppManager.initPayPal = (results) ->
        new Promise (resolve, reject) ->
                try
                        c = {
                                'mode': 'sandbox'
                                'client_id': results[0]
                                'client_secret': results[1]
                        }
                        
                        paypal_rest_sdk.configure(c);

                        resolve()
                        
                catch e
                        reject e
                

class PayPalReq

        constructor: -> @data = {}

        add: (k, v) -> @data[k] = v
