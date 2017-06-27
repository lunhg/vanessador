AppManager::passport = (obj) ->        
        FirebaseStrategy = passport_firebase_auth.Strategy

        passport.use new FirebaseStrategy obj,(accessToken, refreshToken, decodedToken, cb) ->
                ### TODO ###
    
        passport.serializeUser (user, done) -> done null, user.uid
        
        passport.deserializeUser (id, done)->  User.findById(id).exec (err, user) -> done null, user.id
