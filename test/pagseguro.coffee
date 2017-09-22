describe chalk.green('Pagseguro API'), ->


        it "should POST /pagseguro/boleto/gerar/id", ->
                new Promise (resolve, reject) ->
                        agent.post("/pagseguro/boleto/gerar/id")
                                .expect 200
                                .expect (res) ->
                                        console.log res.body
                                .then(resolve)
                                .catch(reject)
                                
        it "should POST /pagseguro/boleto/gerar", ->
                new Promise (resolve, reject) ->
                        agent.post("/pagseguro/boleto/gerar")
                                .query(description: "Tributação e Internet: economia digital")
                                .query(amount:'172.42')
                                .query(to:'gcravista@gmail.com')
                                .expect 200
                                .expect (res) ->
                                        console.log res.body
                                .then(resolve)
                                .catch(reject)
        
