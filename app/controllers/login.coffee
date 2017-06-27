AppManager::login = ->
        @app.get '/auth/firebase', passport.authenticate('firebaseauth', { })

        _callback = passport.authenticate('firebaseauth', { failureRedirect: '/login'})
        @app.get '/auth/firebase/callback', _callback, (req, res) -> res.json({message: "logged"})
