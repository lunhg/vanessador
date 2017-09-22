AppManager::pagseguro = ->

        @app.post '/pagseguro/boleto/gerar/id', (req, res) ->
                PagSeguroSDK.post('/sessions')
                        .then (result) ->
                                xml2js.parseString result, (err, str) ->
                                        if err then res.send err
                                        if not err then res.json JSON.parse(str)
                        .catch (e) ->
                                res.send e
                                
        # Permite consultar os dados de recorrências por intervalo de datas.
        @app.post '/pagseguro/boleto/gerar', (req, res) ->
                PagSeguroSDK.post('/transactions',{
                        paymentMode:'default'
                        paymentMethod:'boleto'
                        currency:'BRL'
                        itemId1:node_uuid.v4()
                        itemDescription1:req.query['description']
                        itemAmount1:req.query['amount']
                        itemQuantity:1
                        senderEmail:req.query['to']
                }).then (result) ->
                        console.log result
                        xml2js.parseString result, (err, str) ->
                                if err then res.send err
                                if not err then res.json JSON.parse(str)
                .catch (e) ->
                        res.send e
                 
