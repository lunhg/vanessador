AppManager::paypal = ->
        create_invoice = (req) ->
                ppr = new PayPalReq()
                ppr.add 'merchant_info', {
                        "email": "gcravista-facilitator@gmail.com",
                        "first_name": "Vanessador",
                        "last_name": "Bot",
                        "business_name": "ITS",
                        "phone": {
                                "country_code": "51",
                                "national_number": "15998006760"
                        },
                        "address": {
                                "line1": "Abolição 403 - Vila Jardini",
                                "city": "Sorocaba",
                                "state": "SP",
                                "postal_code": "18044070",
                                "country_code": "BR"
                        }
                }
                ppr.add "billing_info", [{
                        "email": req.query.billing_info_email
                }]
                ppr.add "items": [{
                        "name": "Boleto de pagamento - ITS - formulário #{req.query.form}",
                        "quantity": 1.0,
                        "unit_price": {
                                "currency": "BRL",
                                "value": req.query.value
                        }
                }]
                ppr.add "note", "Boleto de pagamento #{node_uuid.v4()}",
                ppr.add "payment_term", {
                        "term_type": "NET_45"
                }
                ppr.add "shipping_info", {
                        "first_name": req.query.first_name
                        "last_name": req.query.last_name
                        "business_name": "Not applicable",
                        "phone": {
                                "country_code": req.query.phone_country_code
                                "national_number": req.query.phone_national_number
                        },
                        "address": {
                                "line1": req.query.line,
                                "city": req.query.city,
                                "state": req.query.state
                                "postal_code": req.query.postal_code
                                "country_code": req.query.country_code
                        }
                }
                ppr.add "tax_inclusive", false
                ppr.add "total_amount", {
                        "currency": "BRL",
                        "value": req.query.value
                }

                ppr.data
                
        @app.post '/paypal/invoices/novo', (req, res) ->    
                paypal_rest_sdk.invoice.create create_invoice(req), (err, invoice) ->
                        if err then res.json err
                        res.json invoice.id

        @app.get '/paypal/invoices/:id/number', (req, res) ->
                paypal_rest_sdk.invoice.get req.params.id, (err, invoice) ->
                        if err then res.json err
                        res.json invoice.number
                        
        @app.get '/paypal/invoices/:id/status', (req, res) ->
                paypal_rest_sdk.invoice.get req.params.id, (err, invoice) ->
                        if err then res.json err
                        res.json invoice.status

        @app.get '/paypal/invoices/:id/billing_info', (req, res) ->
                paypal_rest_sdk.invoice.get req.params.id, (err, invoice) ->
                        if err then res.json err
                        res.json invoice.billing_info

        @app.get '/paypal/invoices/:id/invoice_date', (req, res) ->
                paypal_rest_sdk.invoice.get req.params.id, (err, invoice) ->
                        if err then res.json err
                        res.json invoice.invoice_date

        @app.get '/paypal/invoices/:id/total_amount', (req, res) ->
                paypal_rest_sdk.invoice.get req.params.id, (err, invoice) ->
                        if err then res.json err
                        res.json invoice.total_amount
                        
        @app.post '/paypal/invoices/:id/send', (req, res) ->
                paypal_rest_sdk.invoice.send req.params.id, (err, rv) ->
                        if err then res.json err
                        res.json "Um email de notificação está sendo processado pelo PayPal"

        @app.post '/paypal/invoices/:id/remind', (req, res) ->
                options =
                        "subject": "Lembrança de pagamento",
                        "note": "Enviamos este email para lhe lembrar do pagamento do boleto #{req.params.id}",
                        "send_to_merchant": true
                        "send_to_payer": true
                        
                paypal_rest_sdk.invoice.remind req.params.id, options, (err, rv) ->
                        if err then res.json err
                        console.log chalk.green rv
                        res.json "Seu email de notificação está sendo processado pelo PayPal"
                
        @app.post '/paypal/invoices/:id/cancel', (req, res) ->
                options = 
                        "subject": "Cancelamento de pagamento"
                        "note": "Cancelamento do boleto #{req.params.id}",
                        "send_to_merchant": true,
                        "send_to_payer": true
                try
                        paypal_rest_sdk.invoice.cancel req.params.id, options, (err, rv) ->
                                if err then res.json err
                                console.log chalk.green rv
                                res.json "Seu email de notificação está sendo processado pelo PayPal"
                catch
                        res.json err
