AppManager::docs = ->

        root = path.resolve "#{path.join(__dirname)}/../app/assets"
                                        
        @app.get "/docs/:folder/:file", (req, res) ->
                _index = "doc/#{req.params['folder']}/#{req.params['file']}.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/:folder/:sub/:file", (req, res) ->
                _index = "doc/#{req.params['folder']}/#{req.params['sub']}/#{req.params['file']}.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/:app/docco.css", (req, res) ->
                _index = "doc/config/docco.css"
                res.sendFile _index, 'root':root
