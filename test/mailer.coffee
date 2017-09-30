describe chalk.green('Vanessador app mailer'), ->


        it 'should POST /mailer/send/boleto for first time', ->
                new Promise (resolve, reject) ->
                        agent.post('/mailer/send/boleto')
                                .query(subject:"Boleto - Curso Privacidade: Desafios e oportunidades")
                                .query(to:"\"Guilherme Lunhani\" <gcravista@gmail.com>")
                                .query(alumni:0)
                                .expect 201
                                .expect 'Content-Type', /json/
                                .expect (res) ->
                                        console.log res.body
                                        res.body.should.have.property 'message'
                                        res.body.should.have.property 'id'
                                .then resolve
                                .catch reject
