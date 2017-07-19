AppManager::docs = ->

        root = path.resolve "#{path.join(__dirname)}/../app/assets"

        @app.get "/docs", (req, res) ->
                _index = "doc/app/assets/js/index.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/app", (req, res) ->
                _index = "doc/app/assets/js/app.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/config", (req, res) ->
                _index = "doc/app/assets/js/config.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/auth-ctrl", (req, res) ->
                _index = "doc/app/assets/js/auth-ctrl.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/run", (req, res) ->
                _index = "doc/app/assets/js/run.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/services", (req, res) ->
                _index = "doc/app/assets/js/services.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/docco.css", (req, res) ->
                _index = "doc/app/assets/js/docco.css"
                res.sendFile _index, 'root':root
