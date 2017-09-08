describe chalk.green('Vanessador Docs'), ->
        it "should GET /docs/server/boot/dependencies", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/server/boot/dependencies")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/server/boot/devDependencies", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/server/boot/devDependencies")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/server/boot/app", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/server/boot/app")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/server/boot/server", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/server/boot/server")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err


        it "should GET /docs/server/config/environment", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/server/config/environment")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/server/config/app", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/server/config/app")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/server/config/server", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/server/config/server")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/server/config/paypal", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/server/config/paypal")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/server/config/pagseguro", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/server/config/pagseguro")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        #

        it "should GET /docs/server/app/controllers/index", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/server/app/controllers/index")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/server/app/controllers/config", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/server/app/controllers/config")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err


        it "should GET /docs/server/app/controllers/services", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/server/app/controllers/services")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/server/app/controllers/templates", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/server/app/controllers/templates")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/server/app/controllers/typeform", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/server/app/controllers/typeform")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/server/app/controllers/paypal", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/server/app/controllers/paypal")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/server/app/controllers/pagseguro", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/server/app/controllers/pagseguro")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err
