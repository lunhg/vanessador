describe chalk.green('Pagseguro API'), ->

        agent = supertest.agent("http://localhost:3001")
        payment_id = ""
                                        
        it "should POST /pagseguro/planos/requerer\n(Permite criar um plano de pagamento recorrente que concentra todas as configurações de pagamento). Por exemplo, ao criar um curso, criamos um plano de pagamento específico para cada campanha de pagamentos.", ->
                new Promise (resolve, reject) ->
                        setTimeout ->
                                proxy = "https://fmdnocgd.p6.weaved.com"
                                agent.post("/pagseguro/planos/requerer")
                                        .query(name: "Tributação e Internet: economia digital")
                                        .query(amount:'172.42')
                                        .query(redirect_url:proxy+"/#/boletos?type=pagseguro&type=redirect&id=762207c2-fb37-42ca-b555-fa4ce507ce8e")
                                        .query(review_url:proxy+"/#/boletos?type=pagseguro&type=review&id=762207c2-fb37-42ca-b555-fa4ce507ce8e")
                                        .query(details:"762207c2-fb37-42ca-b555-fa4ce507ce8e")
                                        .expect 200
                                        .expect (res) ->
                                                console.log res
                                                #payment_code = res.body["code"]
                                                #payment_code.should.match /[A-Z0-9]/
                                        .then(resolve)
                                        .catch(reject)
                        , 1000
        
        it "should GET /pagseguro/planos", ->
                new Promise (resolve, reject) ->
                        setTimeout ->
                                agent.get("/pagseguro/planos")
                                        .expect 200
                                        .expect (res) ->
                                                console.log res.body
                                        .then(resolve)
                                        .catch(reject)
                        , 1000

        it "should GET /pagseguro/planos/notificacoes", ->
                new Promise (resolve, reject) ->
                        setTimeout ->
                                agent.get("/pagseguro/planos/notificacoes")
                                        .expect 200
                                        .expect (res) ->
                                                console.log res.body
                                        .then(resolve)
                                        .catch(reject)
                        , 1000

        it "should GET /pagseguro/planos/requerer", ->
                new Promise (resolve, reject) ->
                        setTimeout ->
                                agent.get("/pagseguro/planos/requerer")
                                        .expect 200
                                        .expect (res) ->
                                                console.log res.body
                                        .then(resolve)
                                        .catch(reject)
                        , 1000

                        
                        
        it "should POST /pagseguro/planos/requerer", ->
                new Promise (resolve, reject) ->
                        setTimeout ->
                                proxy = "https://ywsjzepx.p19.weaved.com/"
                                agent.post("/pagseguro/planos/requerer")
                                        .query(name: "Teste de cobrança automática")
                                        .query(amount:'10.00')
                                        .query(redirect_url:proxy+"#!/boleto/pagseguro/redirect")
                                        .query(review_url:proxy+"#!/boleto/pagseguro/review")
                                        .query(details:"Plano de cobrança teste")
                                        .expect 200
                                        .expect (res) ->
                                                console.log res.body
                                        .then(resolve)
                                        .catch(reject)
                        , 1000

        it "should GET /pagseguro/planos/requerer", ->
                new Promise (resolve, reject) ->
                        setTimeout ->
                                agent.get("/pagseguro/planos/requerer")
                                        .expect 200
                                        .expect (res) ->
                                                console.log res.body
                                        .then(resolve)
                                        .catch(reject)
                        , 1000
