AppManager::pagseguro = ->

        @app.post '/pagseguro/boleto/gerar/id', (req, res) ->
                PagSeguroSDK.post('/sessions')
                        .then (result) ->
                                xml2js.parseString result, (err, str) ->
                                        if err then res.send err
                                        if not err
                                                res.status 201
                                                res.json JSON.parse(str)
                        .catch (e) ->
                                res.send e
                                
        # Permite consultar os dados de recorrências por intervalo de datas.
        @app.post '/pagseguro/boleto/gerar', (req, res) ->
                PagSeguroSDK.post('/transactions',{
                        payment:
                                mode: 'default'
                                method:'boleto'
                                currency: 'BRL'
                                notificationURL: 'http://192.168.0.11:3000/#/notifica'
                                paymentMode:'default'
                                receiverEmail: 'gcravista@gmail.com'
                                sender:
                                        hash: req.query['hash']
                                        documents:
                                                document:
                                                        type:'CPF'
                                                        value:req.query['cpf']
                                        #bornDate:req.query['bornDate']
                                        phone:
                                                areaCode:'99'
                                                number:'99999999'
                                        name:req.query['nome']
                                        email:req.query['email']
                                items:
                                        item:
                                                id: req.query['id']
                                                description:req.query['description']
                                                amount:req.query['amount']
                                                quantity:1
                                reference:req.query['id']
                                shipping:
                                        address:
                                                street:'NONE'
                                                number:9999
                                                complement:'9o andar'
                                                district:'NONE'
                                                city:req.query['city']
                                                state:req.query['state']
                                                country:'BRA'
                                                postalCode:99999999
                                        type:1
                                        cost:'0.00'
                                        addressRequired:false
                                
                }).then (result) ->
                        console.log result
                        xml2js.parseString result, (err, str) ->
                                if err then res.send err
                                if not err
                                        res.status 201
                                        _json =JSON.parse(str)
                                        console.log _json
                                        res.json _json
                .catch (e) ->
                        res.send e
                 
