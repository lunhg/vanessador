describe chalk.green('Vanessador app'), ->

        agent = supertest.agent("http://localhost:3000")
        payment_id = ""
                
        it 'should GET / for first time', ->
                new Promise (resolve, reject) ->
                        agent.get('/')
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it 'should GET /config', ->
                new Promise (resolve, reject) ->
                        agent.get("/config") 
                                .expect 200
                                .expect('Content-Type', /json/)
                                .expect (res) ->
                                        res.body.should.have.property 'apiKey'
                                        res.body.should.have.property 'messagingSenderId'
                                .then resolve
                                .catch reject

        it 'should GET /templates', ->
                new Promise (resolve, reject) ->
                        array = require('../package.json')['angular-templates']
                        array.push 'route'
                        agent.get("/templates") 
                                .expect 200
                                .expect('Content-Type', /json/)
                                .expect (res) ->
                                        console.log res.body
                                        for e in res.body
                                                console.log e
                                                e.should.have.property 'template'
                                                e.should.have.property 'route'
                                                e.should.have.property 'controller'
                                                e.template.should.be.String()
                                                e.route.should.be.String()
                                                e.route.should.match /\/(\w+(\/\w+)?)?/
                                                e.controller.should.be.String()
                                                e.controller.should.match /[A-Z][a-z]+[A-Z][a-z]+/
                                                
                                .then resolve
                                .catch reject

        it 'should GET /directives', ->
                new Promise (resolve, reject) ->
                        agent.get("/directives")
                                .expect 200
                                .expect('Content-Type', /json/)
                                .expect (res) ->
                                        console.log res.body
                                .then resolve
                                .catch reject
                                
        it 'should GET /services', ->
                new Promise (resolve, reject) ->
                        agent.get("/services")
                                .expect 200
                                .expect('Content-Type', /json/)
                                .expect (res) ->
                                        console.log res.body
                                .then resolve
                                .catch reject   
                                                                      
                                
        it 'should GET /typeform/data-api', ->
                new Promise (resolve, reject) ->
                        agent.get("/typeform/data-api")
                                .query({uuid: 'lD2u6E'})
                                .query({completed: true})
                                .query({limit: 10})
                                .expect 200
                                .expect('Content-Type', /json/)
                                .expect (res) ->
                                        res.body.should.have.property 'stats'
                                        res.body.stats.should.have.property 'responses'
                                        res.body.stats.responses.should.have.property 'showing'
                                        res.body.stats.responses.should.have.property 'total'
                                        res.body.stats.responses.should.have.property 'completed'
                                        res.body.should.have.property 'questions'
                                        
                                .then resolve
                                .catch reject

                                
        it "should POST /paypal/boletos/novo", ->
                new Promise (resolve, reject) ->
                        agent.post("/paypal/invoices/novo")
                                .query(first_name: "NodeJS")
                                .query(second_name: "Teste")
                                .query(phone_country_code: "51")
                                .query(phone_national_number: "1234567890")
                                .query(line: "Internet, Proxy IP")
                                .query(city: "Provedor")
                                .query(state: "Web")
                                .query(postal_code: "127.0.0.0")
                                .query(country_code: "BR")
                                .query(value:'10.00')
                                .query(billing_info_email:'gcravista-buyer@gmail.com')
                                .query(form:'lD26uE')
                                .expect 200
                                .expect('Content-Type', /json/)
                                .expect (res) ->
                                        payment_id = res.body
                                        res.body.should.match /[A-Z0-9]+\-[A-Z0-9]+\-[A-Z0-9]+\-[A-Z0-9]+/
                                .then resolve
                                .catch reject 


        it "should GET /paypal/invoices/:id/number", ->
                new Promise (resolve, reject) ->
                        agent.get("/paypal/invoices/#{payment_id}/number")
                                .expect 200
                                .expect 'Content-Type', /json/
                                .expect (res) ->
                                        res.body.should.match /\d+/
                                .then(resolve)
                                .catch(reject)
                                
        it "should GET /paypal/invoices/:id/status", ->
                new Promise (resolve, reject) ->
                        agent.get("/paypal/invoices/#{payment_id}/status")
                                .expect 200
                                .expect 'Content-Type', /json/
                                .expect (res) ->
                                        res.body.should.equal 'DRAFT'
                                .then(resolve)
                                .catch(reject)

        it "should GET /paypal/invoices/:id/billing_info", ->
                new Promise (resolve, reject) ->
                        setTimeout ->
                                agent.get("/paypal/invoices/#{payment_id}/billing_info")
                                        .expect 200
                                        .expect 'Content-Type', /json/
                                        .expect (res) ->
                                                res.body.should.be.Array()
                                                res.body[0].should.be.Object()
                                                res.body[0].should.have.property 'email'
                                                res.body[0].email.should.match /[a-z0-9]+\@[a-z]+\.[a-z]{3}/
                                        .then(resolve)
                                        .catch(reject)
                        , 1000

        it "should GET /paypal/invoices/:id/invoice_date", ->
                new Promise (resolve, reject) ->
                        setTimeout ->
                                agent.get("/paypal/invoices/#{payment_id}/invoice_date")
                                        .expect 200
                                        .expect (res) ->
                                                res.body.should.be.String()
                                                res.body.should.match /\d{4}\-\d{2}-\d{2}\s[A-Z]{3}/
                                        .then(resolve)
                                        .catch(reject)
                        , 1000

        it "should GET /paypal/invoices/:id/total_amount", ->
                new Promise (resolve, reject) ->
                        setTimeout ->
                                agent.get("/paypal/invoices/#{payment_id}/total_amount")
                                        .expect 200
                                        .expect (res) ->
                                                res.body.should.have.property 'currency'
                                                res.body.should.have.property 'value'
                                                res.body.currency.should.match /[A-Z]{3}/
                                                res.body.value.should.match /\d+\.\d+/
                                        .then(resolve)
                                        .catch(reject)
                        , 1000

        it "should POST /paypal/invoices/:id/send", ->
                new Promise (resolve, reject) ->
                        setTimeout ->
                                agent.post("/paypal/invoices/#{payment_id}/send")
                                        .expect 200
                                        .expect 'Content-Type', /json/
                                        .expect (res) ->
                                                res.body.should.be.String()
                                        .then(resolve)
                                        .catch(reject)
                        , 1000
                        
        it "should GET /paypal/invoices/:id/status a second time with SENT status", ->
                new Promise (resolve, reject) ->
                        setTimeout ->
                                agent.get("/paypal/invoices/#{payment_id}/status")
                                        .expect 200
                                        .expect 'Content-Type', /json/
                                        .expect (res) ->
                                                res.body.should.equal 'SENT'
                                        .then(resolve)
                                        .catch(reject)
                        , 1000

        it "should POST /paypal/invoices/:id/remind", ->
                new Promise (resolve, reject) ->
                        setTimeout ->
                                agent.post("/paypal/invoices/#{payment_id}/remind")
                                        .expect 200
                                        .expect (res) ->
                                                res.body.should.be.String()
                                        .then(resolve)
                                        .catch(reject)
                        , 1000
                        
        it "should POST /paypal/invoices/:id/cancel", ->
                new Promise (resolve, reject) ->
                        setTimeout ->
                                agent.post("/paypal/invoices/#{payment_id}/cancel")
                                        .expect 200
                                        .expect (res) ->
                                                res.body.should.be.String()
                                        .then(resolve)
                                        .catch(reject)
                        , 1000
                        
        it "should GET /paypal/invoices/:id/status a third time, with status CANCELLED", ->
                new Promise (resolve, reject) ->
                        agent.get("/paypal/invoices/#{payment_id}/status")
                                .expect 200
                                .expect 'Content-Type', /json/
                                .expect (res) ->
                                        res.body.should.equal 'CANCELLED'
                                .then(resolve)
                                .catch(reject)

         it "should POST /paypal/boletos/novo", ->
                new Promise (resolve, reject) ->
                        agent.post("/paypal/invoices/novo")
                                .query(first_name: "NodeJS")
                                .query(second_name: "Teste 2")
                                .query(phone_country_code: "51")
                                .query(phone_national_number: "1234567890")
                                .query(line: "Internet, Proxy IP")
                                .query(city: "Provedor")
                                .query(state: "Web")
                                .query(postal_code: "127.0.0.0")
                                .query(country_code: "BR")
                                .query(value:'10.00')
                                .query(billing_info_email:'gcravista-buyer@gmail.com')
                                .query(form:'lD26uE')
                                .expect 200
                                .expect('Content-Type', /json/)
                                .expect (res) ->
                                        payment_id = res.body
                                        res.body.should.match /[A-Z0-9]+\-[A-Z0-9]+\-[A-Z0-9]+\-[A-Z0-9]+/
                                .then resolve
                                .catch reject
                                
        it "should DELETE /paypal/invoices/:id", ->
                new Promise (resolve, reject) ->
                        setTimeout ->
                                agent.delete("/paypal/invoices/#{payment_id}")
                                        .expect 200
                                        .expect (res) ->
                                                res.body.should.be.String()
                                        .then(resolve)
                                        .catch(reject)
                        , 1000
                        
        it "should GET /docs", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/app", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/app")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/services", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/run")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/config", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/config")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err


        it "should GET /docs/auth-ctrl", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/auth-ctrl")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/run", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/run")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

                                                        
