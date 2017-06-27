AppManager::index = ->
        @app.get '/', (req, res) ->
                firebase.auth().onAuthStateChanged (user) ->
                        if user
                                res.render 'index', user
                        else
                                res.render 'index'
