describe chalk.green('Vanessador app client'), ->


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
