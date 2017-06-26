AppManager::index = ->
        @app.get '/', (req, res) ->
                passport.authenticate('local-dashboard', (err, user, info) ->
                        if not err
                                res.render 'index', user: user
                        else
                                res.render 'index'
                )(req, res)
