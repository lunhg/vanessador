describe chalk.green('Vanessador Internal Rest API'), ->

        routes = []
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

        it 'should GET /templates/index/page', ->
                new Promise (resolve, reject) ->
                        agent.get("/templates/index/page") 
                                .expect 200
                                .expect('Content-Type', /html/)
                                .then resolve
                                .catch reject 

        it 'should GET /templates/index/data', ->
                new Promise (resolve, reject) ->
                        agent.get("/templates/index/data") 
                                .expect 200
                                .expect('Content-Type', /json/)
                                .expect (res) ->
                                        res.body.should.be.an.Object()
                                .then resolve
                                .catch reject

        it 'should GET /templates/index/routes', ->
                new Promise (resolve, reject) ->
                        agent.get("/templates/index/routes") 
                                .expect 200
                                .expect('Content-Type', /json/)
                                .expect (res) ->
                                        routes = res.body
                                        res.body.should.be.an.Array()
                                .then resolve
                                .catch reject 

        it 'should GET /templates/routes/_index', ->
                new Promise (resolve, reject) ->
                        agent.get("/templates/routes/page") 
                                .expect 200
                                .expect('Content-Type', /json/)
                                .then resolve
                                .catch reject 

        it 'should GET /templates/routes/login', ->
                new Promise (resolve, reject) ->
                        agent.get("/templates/routes/page") 
                                .expect 200
                                .expect('Content-Type', /json/)
                                .then resolve
                                .catch reject 

        it 'should GET /templates/routes/signup', ->
                new Promise (resolve, reject) ->
                        agent.get("/templates/routes/page") 
                                .expect 200
                                .expect('Content-Type', /json/)
                                .then resolve
                                .catch reject
                                
        it 'should GET /templates/routes/confirm', ->
                new Promise (resolve, reject) ->
                        agent.get("/templates/routes/page") 
                                .expect 200
                                .expect('Content-Type', /json/)
                                .then resolve
                                .catch reject

        it 'should GET /templates/routes/formularios', ->
                new Promise (resolve, reject) ->
                        agent.get("/templates/routes/formularios") 
                                .expect 200
                                .expect('Content-Type', /json/)
                                .then resolve
                                .catch reject

        it 'should GET /templates/routes/estudantes', ->
                new Promise (resolve, reject) ->
                        agent.get("/templates/routes/estudantes") 
                                .expect 200
                                .expect('Content-Type', /json/)
                                .then resolve
                                .catch reject
                                
        it 'should GET /templates/routes/cursos', ->
                new Promise (resolve, reject) ->
                        agent.get("/templates/routes/cursos") 
                                .expect 200
                                .expect('Content-Type', /json/)
                                .then resolve
                                .catch reject

        it 'should GET /templates/routes/matriculas', ->
                new Promise (resolve, reject) ->
                        agent.get("/templates/routes/matriculas") 
                                .expect 200
                                .expect('Content-Type', /json/)
                                .then resolve
                                .catch reject 
