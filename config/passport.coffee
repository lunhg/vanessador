parseBasic = (result) ->
        new Promise (resolve, reject) ->
                o = {}
                for r in result
                        c = r.split("=")
                        o[c[0]] = c[1]
                resolve o
 
getAuth = (req) ->
        new Promise (resolve, reject) ->
                #bytes = req.headers.authorization.split("Basic ")[1]
                #r =  atob(bytes).split(":")
                #console.log r
                resolve req.query['email']
                
AppManager::passport = ->        
        #FirebaseStrategy = passport_firebase_auth.Strategy

        #passport.use new FirebaseStrategy obj,(accessToken, refreshToken, decodedToken, cb) ->
                ### TODO ###
    
        #passport.serializeUser (user, done) -> done null, user.uid
        
        #passport.deserializeUser (id, done)->  User.findById(id).exec (err, user) -> done null, user.id

        passport.use 'firebase-admin-login', new passport_custom (req, done) ->
                onErr = (error) ->
                        console.log error
                        done error.code, null, message: error.message
                        
                onUser = (userRecord) ->
                        uid = userRecord.toJSON().uid
                        firebase_admin.auth()
                                .createCustomToken(uid)
                                .then (customToken) ->
                                        console.log customToken
                                        done null, uid, customToken: customToken
                                .catch onErr
                                
                getAuth(req).then (email) ->
                        firebase_admin.auth()
                                .getUserByEmail(email)
                                .then onUser
                                .catch onErr
                        .catch onErr
                        
        
        passport.serializeUser (user, done) -> done null, user.uid

        passport.deserializeUser (id, done)->  done id
