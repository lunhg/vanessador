AppManager::index = ->
        @app.get '/', (req, res) -> res.render 'index'

        
