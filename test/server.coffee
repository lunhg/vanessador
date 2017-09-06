describe chalk.green('Vanessador app'), ->

        agent = supertest.agent("http://localhost:3001")
        payment_id = ""
                                        
        it "should POST /pagseguro/planos/requerer\n(Permite criar um plano de pagamento recorrente que concentra todas as configurações de pagamento).", ->
                new Promise (resolve, reject) ->
                        setTimeout ->
                                proxy = "https://ywsjzepx.p19.weaved.com/"
                                agent.post("/pagseguro/planos/requerer")
                                        .query(name: "Boleto Teste")
                                        .query(amount:'10.00')
                                        .query(redirect_url:proxy+"/#/boleto/pagseguro/redirect")
                                        .query(review_url:proxy+"#/boleto/pagseguro/review")
                                        .query(details:"Plano de cobrança teste")
                                        .expect 200
                                        .expect (res) ->
                                                console.log res.body
                                                payment_id = res.body["preApprovalRequest"]["code"][0]
                                        .then(resolve)
                                        .catch(reject)
                        , 1000

        it "should GET /pagseguro/planos/requerer", ->
                new Promise (resolve, reject) ->
                        setTimeout ->
                                agent.get("/pagseguro/planos/requerer")
                                        .expect 200
                                        .expect (res) ->
                                                res.body.should.be.deepEqual {}
                                        .then(resolve)
                                        .catch(reject)
                        , 1000

        it "should PUT /pagseguro/planos/:id", ->
                new Promise (resolve, reject) ->
                        setTimeout ->
                                agent.put("/pagseguro/planos/#{payment_id}")
                                        .query(amount:'11.00')
                                        .query(update:false)
                                        .expect 200
                                        .expect (res) ->
                                                console.log res.body
                                        .then(resolve)
                                        .catch(reject)
                        , 1000
