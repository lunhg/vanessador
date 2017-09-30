describe chalk.green('Paypal Invoice API'), ->

        payment_id = ""
        
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
