describe chalk.green('Vanessador Docs'), ->

        it "should GET /docs/boot/dependencies", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/boot/dependencies")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

         it "should GET /docs/boot/devDependencies", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/boot/devDependencies")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

         it "should GET /docs/boot/server", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/boot/server")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/config/environment", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/config/environment")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/config/app", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/config/app")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/config/pagseguro", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/config/pagseguro")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/config/server", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/config/server")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/boot/app", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/boot/app")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/app/controllers/index", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/app/controllers/index")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/app/controllers/config", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/app/controllers/config")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/app/controllers/templates", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/app/controllers/templates")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/app/controllers/services", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/app/controllers/services")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/app/controllers/typeform", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/app/controllers/typeform")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/app/controllers/pagseguro", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/app/controllers/pagseguro")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/app/controllers/mailer", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/app/controllers/mailer")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/app/controllers/docs", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/app/controllers/docs")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/test/agent", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/test/agent")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/test/internal", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/test/internal")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err

        it "should GET /docs/test/docs", ->
                new Promise (resolve, reject) ->
                        agent.get("/docs/test/docs")
                                .expect 200
                                .expect 'Content-Type', /html/
                                .end (err, res) ->
                                        if not err
                                                resolve()
                                        else
                                                reject err
