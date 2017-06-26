# Create a local strategy
parseBasic = (result) ->
        new Promise (resolve, reject) ->
                o = {}
                for r in result
                        c = r.split("=")
                        o[c[0]] = c[1]
                resolve o

getAuth = (req) ->
        new Promise (resolve, reject) ->
                bytes = req.headers.authorization.split("Basic ")[1]
                resolve atob(bytes).split(":")

beforeLogin = (req, res, next) ->
        if firebase.auth().currentUser
                redirect '/dashboard'
        else
                next()



# login with email or passowrd
# with Basic auth                 
passport.use 'local-dashboard', new passport_custom (req, done) ->
        firebase.auth().onAuthStateChanged (user) ->
                if user
                        # User is signed in.
                        done null, user
                else
                        done true
                        
#No user is signed in.
passport.use "local-login", new passport_custom (req, done) ->
        getAuth(req).then(parseBasic).then (result) ->
                firebase.auth().signInWithEmailAndPassword(result.email, result.password)
                        .then (x) ->
                                user = firebase.auth().currentUser
                                done null, user
                        .catch (error) ->
                                # Handle Errors here.
                                done error.code, error.message

# remove account
passport.use 'local-logout', new passport_custom (req, done) ->
        onSignout = ->
                done null
        onError = (error) -> done error
        firebase.auth().signOut().then onSignout, onError
                                
                        
passport.serializeUser (user, done) -> done null, user.uid

passport.deserializeUser (id,done)->  done id
