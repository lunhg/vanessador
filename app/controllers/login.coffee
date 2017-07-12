AppManager::login = ->
        @app.post '/auth/callback', (req, res) ->
                passport.authenticate('firebase-login', (err, user, info) ->
                        if err
                                res.json err
                        else
                                res.json {
                                        user: user
                                        info: info
                                }
                )(req, res)
