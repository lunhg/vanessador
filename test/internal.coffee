describe chalk.green('Vanessador Internal Rest API'), ->

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
                                        for e in res.body
                                                e.should.have.property 'template'
                                                e.should.have.property 'route'
                                                e.should.have.property 'controller'
                                                e.template.should.be.String()
                                                e.route.should.be.String()
                                                e.route.should.match /\/(\w+(\/\w+)?)?/
                                                
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
