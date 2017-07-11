class FirebaseAdmin

        constructor: (@projectName) ->
                
        # Initialize Firebase application
        # Your configuration must have an API key
        # and messagingSenderId, created on https://console.firebase.google.com
        init: (apiKey) ->
                self = this
                new Promise (resolve, reject) ->
                        fa = firebase_admin.initializeApp
                                credential: firebase_admin.credential.cert(apiKey),
                                databaseURL: "https://#{self.projectName}.firebaseio.com",
                        if fa
                                resolve {
                                        firebaseProjectId: self.projectName,
                                        authorizationURL: '/auth',
                                        callbackURL: '/auth/firebase/callback'
                                }
                        else
                                reject()
                                
        # Once these strings are important ones, lets get them from
        # keychain, stored when you run
        # Gruntfile build:firebase:apiKey
        getAPIKey: ->
                self = this
                new Promise (resolve, reject) ->
                        console.log "Checking firebase apiKey for #{projectName}..."
                        require('keytar')
                                .findPassword("#{projectName}.firebase.apiKey")
                                .then (apiKey) ->
                                        resolve apiKey  
                                .catch (err) ->
                                        reject e 
