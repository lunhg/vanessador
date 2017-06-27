AppManager::logout = ->
        @app.post '/logout', (req, res) ->
                passport.authenticate('local-logout', (err, user, info) ->
                        if err then res.send err
                        res.json "logged out"
                )(req, res)
