describe chalk.green('Pagseguro API'), ->


        it "should POST /pagseguro/boleto/gerar/id", ->
                new Promise (resolve, reject) ->
                        agent.post("/pagseguro/boleto/gerar/id")
                                .expect 201
                                .expect (res) ->
                                        res.body
                                .then(resolve)
                                .catch(reject)
                                
        it "should POST /pagseguro/boleto/gerar", ->
                new Promise (resolve, reject) ->
                        agent.post("/pagseguro/boleto/gerar")
                                .query(description: "Tributação e Internet: economia digital")
                                .query(name:'Joao Comprador')
                                .query(email:'c37421934304578448359@sandbox.pagseguro.com.br')
                                .query(city:'Rio de Janeiro')
                                .query(state:'RJ')
                                .query(amount:'172.42')
                                .query(cpf:'11111111111')
                                .query(hash:node_uuid.v4())
                                .query(id:node_uuid.v4())
                                .expect 201
                                .expect (res) ->
                                        console.log res.body
                                .then(resolve)
                                .catch(reject)
        
