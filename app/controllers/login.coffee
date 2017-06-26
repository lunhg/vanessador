AppManager::login = ->
        @app.post '/login', [beforeLogin], (req, res) ->
                passport.authenticate('local-login', (err, user, info) ->
                        if err then res.send err
                        res.json user
                )(req, res)
