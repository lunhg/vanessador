describe chalk.green('Vanessador app'), ->

        agent = supertest.agent("http://localhost:3000")
        
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

                                                        
