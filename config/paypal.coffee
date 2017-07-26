AppManager.initPayPal = (results) ->
        new Promise (resolve, reject) ->
                try
                        c = {
                                'mode': 'sandbox'
                                'client_id': results[0]
                                'client_secret': results[1]
                        }
                        _c = {
                                'mode': 'sandbox'
                                'client_id': 'ATRMLn-_R6kkGYPoHvuES42_dKGhT8LbV4TjBvN6ox6vh8t4cUmneSiRY-Ord1t16mhizMRVGp1Y2EaF',
                                'client_secret': 'ELL8WYaMXwz0tlJ7vHZNI2g7BfQPt76qjfmEzPR2RcOOBU7nEg5A8Uy7zD09D3VfAltGNw_n0BG_a_gY',
                        }
                        
                        paypal_rest_sdk.configure(c);

                        resolve()
                        
                catch e
                        reject e
                

class PayPalReq

        constructor: -> @data = {}

        add: (k, v) -> @data[k] = v
