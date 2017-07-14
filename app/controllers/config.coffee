AppManager::config = ->
        @app.get '/config', (req, res) ->
                projectName = require("#{path.join(__dirname)}/../package.json").firebase.project.name
                keytar.findPassword("#{projectName}.firebase.apiKey")
                        .then (apiKey) ->
                                keytar.findPassword("#{projectName}.firebase.messagingSenderId")
                                        .then (messagingSenderId) ->
                                                res.json
                                                        apiKey: apiKey,
                                                        authDomain: "#{projectName}.firebaseapp.com",
                                                        databaseURL: "https://#{projectName}.firebaseio.com",
                                                        projectId: projectName,
                                                        storageBucket: "#{projectName}.appspot.com",
                                                        messagingSenderId: messagingSenderId
