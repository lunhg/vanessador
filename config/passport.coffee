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

        passport.use 'firebase-login', new passport_custom (req, done) ->
                firebase_admin.auth()
                        .getUser(req.query.uid)
                        .then (userRecord) ->
                                user = userRecord.toJSON()
                                console.log user
                                if user.accessToken is req.query.accessToken
                                        done null, userRecord.toJSON(), message: "User #{user.uid} logged"
                                else
                                        done true
                                        
                        .catch (err) -> done err.code, null, message: err.message
        
        passport.serializeUser (user, done) -> done null, user.uid

        passport.deserializeUser (id, done)->  done id
