AppManager::pagseguro = ->

        onParseXML = (result) ->
                self = this
                new Promise (resolve, reject) ->
                        xml2js.parseString result, (err, str) ->
                                if err then reject err
                                if not err then self.res.json JSON.parse(str)


        # Permite consultar os dados de recorrências por intervalo de datas.
        @app.get '/pagseguro/planos', (req, res) ->
                 PagSeguroSDK.get('/pre-approvals').then(onParseXML.bind(res:res)).catch (e) -> res.send e

        # Permite aderir a um pagamento recorrente (assinar um plano criado).
        @app.post '/pagseguro/planos', (req, res) ->
                PagSeguroSDK.post('/pre-approvals/request', {
                        "directPreApproval": {
                                "plan": req.query['plan']
                                "reference": req.query['ref']
                                "sender":{
                                        "name":req.query['nome']
                                        "email":req.query['email']
                                        "ip":req.ip
                                        "hash":node_uuid.v4()
                                        "phone":{
                                                "areacode":req.query['areacode']
                                                "number":req.query['number']
                                        }
                                        "documents":{
                                                "document":{
                                                        "type":req.query['doc_type']
                                                        "number":req.query['doc_num']
                                                }
                                        }
                                }
                                "paymentMethod":{
                                        "token": req.query['payment_token']
                                        "type": req.query['payment_type']
                                        "holder":{
                                                "name":req.query['nome']
                                                "birthDate":req.query['birthDate']
                                                "document":{
                                                        "type":req.query['doc_type']
                                                        "number":req.query['doc_num']
                                                }
                                                "phone":{
                                                        "areacode":req.query['areacode']
                                                        "number":req.query['number']
                                                }
                                        }
                                }
                        }
                }).then(onParseXML.bind(res:res)).catch (e) -> res.send e
                                

        # Permite consultar os dados de uma recorrência por intervalo de dias.
        @app.get '/pagseguro/planos/notificacoes', (req, res) ->
                 PagSeguroSDK.get("/pre-approvals/notifications?page=#{req.query['page']}&maxPagesResults=50&interval=#{req.query['dias']}").then(onParseXML.bind(res:res)).catch (e) -> res.send e

        # Permite consultar os dados de uma recorrência pelo código da notificação.
        @app.get '/pagseguro/planos/notificacoes/:id', (req, res) ->
                 PagSeguroSDK.get("/pre-approvals/notifications/#{req.params['id']}").then(onParseXML.bind(res:res)).catch (e) -> res.send e

        # Permite efetuar uma cobrança manual.
        @app.post '/pagseguro/planos/pagamento/:id', (req, res) ->
                id = node_uuid.v4()
                PagSeguroSDK.post('/pre-approvals/payment', {
                        "payment": {
                                "preApprovalCode": req.query['code']
                                "reference": req.query['ref']
                                "senderHash": node_uuid.v4()
                                "senderIp": req.ip
                                "items": [{
                                        "id": req.params['id']
                                        "description": "Boleto de pagamento",
                                        "quantity": 1,
                                        "amount": "10.00",
                                        "weight": 1,
                                        "shippingCost": 0.00
                                }]
                        }
                }).then(onParseXML.bind(res:res)).catch (e) -> res.send e
                
        # Permite consultar os dados de planos.
        @app.get '/pagseguro/planos/requerer', (req, res) ->
                 PagSeguroSDK.get('/pre-approvals/request').then(onParseXML.bind(res:res)).catch (e) -> res.send e

        # Permite criar um plano de pagamento recorrente que concentra todas as configurações de pagamento.
        @app.post '/pagseguro/planos/requerer', (req, res) ->
                PagSeguroSDK.post('/pre-approvals/request', {
                        "preApprovalRequest": {
                                "redirect_url":req.query['redirect_url'],
                                "redirect_url":req.query['review_url'],
                                "reference": req.query['ref']
                                "preApproval": {
                                        "name": req.query['name'],
                                        "charge": "AUTO",
                                        "period": "MONTHLY",
                                        "amountPerPayment": req.query['amount'],
                                        "membershipFee": (parseFloat(req.query['amount']) * 0.05).toFixed(2),
                                        "expiration": {
                                                "value": 1,
                                                "unit": "MONTHS"
                                        }
                                        "details": 'ITS_'+node_uuid.v4()
                                }
                        }
                }).then(onParseXML.bind(res:res)).catch (e) -> res.send e

        # Permite alterar o valor de cobrança do plano e das adesões vigentes do plano.
        @app.put '/pagseguro/planos/:id', (req, res) ->
                PagSeguroSDK.put("/pre-approvals/#{req.params['id']}/payment", {
                        "amountPerPayment":req.query['amount']
                        "updateSubscriptions":req.query['update']
                }).then(onParseXML.bind(res:res)).catch (e) -> res.send e

        # Permite criar um plano de pagamento
        # recorrente que concentra todas as configurações de pagamento.
        @app.get '/pagseguro/planos/:id', (req, res) ->
                PagSeguroSDK.get("/pre-approvals/#{req.params['id']}").then(onParseXML.bind(res:res)).catch (e) -> res.send e
                
        # Permite consultar os dados de uma recorrência.
        @app.put '/pagseguro/planos/:id/cancela', (req, res) ->
                PagSeguroSDK.put("/pre-approvals/#{req.params['id']}/payment", {
                        "pre-approval-code":req.query['code']
                }).then(onParseXML.bind(res:res)).catch (e) -> res.send e

        # Permite conceder desconto à próxima cobrança.
        @app.put '/pagseguro/plano/:id/desconto', (req, res) ->
                PagSeguroSDK.put("/pre-approvals/#{req.params['id']}/payment", {
                        "type":"DISCOUNT_PERCENT"
                        "value":req.params['value']
                }).then(onParseXML.bind(res:res)).catch (e) -> res.send e

        # Permite listar as ordens de pagamento de uma assinatura.
        @app.get '/pagseguro/plano/:id/ordens', (req, res) ->
                PagSeguroSDK.get("/pre-approvals/#{req.params['id']}/payment-orders").then(onParseXML.bind(res:res)).catch (e) -> res.send e

        # Permite efetuar a retentativa de cobrança de uma ordem de pagamento não paga ou não processada.
        @app.post '/pagseguro/plano/:id/ordens/:pid', (req, res) ->
                PagSeguroSDK.get("/pre-approvals/#{req.params['id']}/payment-orders/#{req.params['pid']}/payment").then(onParseXML.bind(res:res)).catch (e) -> res.send e

        # Permite alterar o estado de uma recorrência.
        @app.put '/pagseguro/plano/:id/ordens/:pid', (req, res) ->
                PagSeguroSDK.get("/pre-approvals/#{req.params['id']}/status", {
                        "status":req.query['status']
                }).then(onParseXML.bind(res:res)).catch (e) -> res.send e

        # Permite a alteração do cartão de crédito atrelado
        # ao pagamento do plano para as próximas cobranças.
        @app.put '/pagseguro/plano/:id/ordens/:pid', (req, res) ->
                PagSeguroSDK.get("/pre-approvals/#{req.params['id']}/status", {
                        "type": "CREDITCARD",
                        "sender": {
                                "ip": req.ip
                                "hash": node_uuid.v4()
                        },
                        "creditCard": {
                                "token": req.query['token']
                                "holder": {
                                        "name":req.query['nome']
                                        "birthDate":req.query['birthDate']
                                        "document":{
                                                "type":req.query['doc_type']
                                                "number":req.query['doc_num']
                                        }
                                        "phone":{
                                                "areacode":req.query['areacode']
                                                "number":req.query['number']
                                        }
                                }
                        }
                }).then(onParseXML.bind(res:res)).catch (e) -> res.send e
