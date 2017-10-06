AppManager::config = ->
        
        @app.get '/config', (req, res) ->
                projectName = require("#{path.join(__dirname)}/../package.json").firebase.project

                prj = projectName.development
                res.json {
                        apiKey: process.env.FIREBASE_API_KEY,
                        authDomain: "#{prj}.firebaseapp.com",
                        databaseURL: "https://#{prj}.firebaseio.com",
                        projectId: prj
                        storageBucket: "#{projectName}.appspot.com",
                        messagingSenderId: process.env.FIREBASE_MESSAGING_SENDER_ID
                }
                
