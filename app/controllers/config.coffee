AppManager::config = ->
        
        @app.get '/config', (req, res) ->
                projectName = require("#{path.join(__dirname)}/../package.json").firebase.project
                config = dotenv.config()
                
                prj = projectName[process.env.VANESSADOR_ENV]
                res.json {
                        apiKey: process.env.FIREBASE_API_KEY,
                        authDomain: "#{prj}.firebaseapp.com",
                        databaseURL: "http://#{process.env.PROJECT_ID}.firebaseio.com",
                        projectId: process.env.PROJECT_ID
                        storageBucket: "#{projectName}.appspot.com",
                        messagingSenderId: process.env.FIREBASE_MESSAGING_SENDER_ID
                }
                
