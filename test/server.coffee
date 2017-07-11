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
                                
                        
        it 'should POST /login', ->
                new Promise (resolve, reject) ->
                        agent.post("/login") 
                                .query({email: "lunhanig@gmail.com"})
                                .expect 200
                                .expect('Content-Type', /json/)
                                .expect (res) ->
                                        res.body.should.have.property 'uid'
                                        res.body.uid.should.be.String()
                                        res.body.should.have.property 'info'
                                        res.body.info.should.have.property 'customToken'
                                        res.body.info.customToken.should.be.String()
                                .then resolve
                                .catch reject
