AppManager::signup = -> @app.post '/signup', (req, res) ->
        passport.authenticate('local-signup', (err, user, info) ->
                if err then res.send err
                res.json user        
        )(req, res)
