AppManager::config = ->
        
        @app.get '/config', (req, res) ->
                projectName = require("#{path.join(__dirname)}/../package.json").firebase.project.name
                
                res.json {
                        apiKey: process.env.FIREBASE_API_KEY,
                        authDomain: "#{projectName}.firebaseapp.com",
                        databaseURL: "https://#{projectName}.firebaseio.com",
                        projectId: projectName,
                        storageBucket: "#{projectName}.appspot.com",
                        messagingSenderId: process.env.FIREBASE_MESSAGING_SENDER_ID
                }
                
