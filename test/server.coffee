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
                                .auth('email=lunhg@gmail.com', "password=..senha123")
                                #.expect 200
                                #.expect('Content-Type', /json/)
                                .expect (res) ->
                                        console.log res.body
                                .then resolve
                                .catch reject
