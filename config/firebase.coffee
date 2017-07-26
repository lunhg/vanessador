class FirebaseAdmin

        constructor: (@projectName) ->
                
        # Initialize Firebase application
        # Your configuration must have an API key
        # and messagingSenderId, created on https://console.firebase.google.com
        init:  ->
                url = "https://#{@projectName}.firebaseio.com"
                new Promise (resolve, reject) ->
                        serviceAccount = require("#{path.join(__dirname)}/../firebase.json")
                        
                        console.log url
                        fa = firebase_admin.initializeApp
                                credential: firebase_admin.credential.cert(serviceAccount)
                                databaseURL: url
                        if fa
                                resolve()
                        else
                                reject()
                        
