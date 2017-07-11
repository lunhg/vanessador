AppManager::login = ->
        @app.post '/login', (req, res) ->
                passport.authenticate('firebase-admin-login', (err, uid, info) ->
                        if err
                                res.json err
                        else
                                res.json {
                                        uid: uid
                                        info: info
                                }
                )(req, res)
