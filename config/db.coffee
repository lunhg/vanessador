# Initialize Firebase application
# Your configuration must have an API key
# and messagingSenderId, created on https://console.firebase.google.com
makeConfig = (projectName, apiKey, messagingSenderId) ->
        config =
                apiKey: apiKey
                authDomain: "#{projectName}.firebaseapp.com",
                databaseURL: "https://#{projectName}.firebaseio.com",
                projectId: projectName,
                storageBucket: "#{projectName}.appspot.com"
                messagingSenderId: messagingSenderId

# Once these strings are important ones, lets get them from
# keychain, stored when you run
# Gruntfile build:firebase:apiKey and build:firebase:messagingSenderId
firebase_init = (projectName) ->
        new Promise (resolve, reject) ->
                console.log "Checking firebase apiKey for #{projectName}..."
                require('keytar').findPassword("#{projectName}.firebase.apiKey").then (apiKey) ->
                        if apiKey isnt null
                                console.log "OK"
                                console.log "Checking messagingSenderId for #{projectName}..."
                                require('keytar').findPassword("#{projectName}.firebase.messagingSenderId")
                                        .then (messagingSenderId) ->
                                                console.log "OK"
                                                if messagingSenderId isnt null
                                                        cfg = makeConfig projectName,apiKey,messagingSenderId
                                                        # console.log cfg
                                                        firebase.initializeApp cfg
                                                        resolve firebase.app()
                                        .catch (err) ->
                                                reject e 
