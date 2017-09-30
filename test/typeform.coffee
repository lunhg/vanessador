describe chalk.green('Typeform Data API'), ->
                                       
        it 'should GET /typeform/data-api', ->
                new Promise (resolve, reject) ->
                        agent.get("/typeform/data-api")
                                .query({uuid: 'E20qGg'})
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
