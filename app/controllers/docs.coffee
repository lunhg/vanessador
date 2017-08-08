AppManager::docs = ->

        root = path.resolve "#{path.join(__dirname)}/../app/assets"

        @app.get "/docs", (req, res) ->
                _index = "doc/app/assets/js/index.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/index", (req, res) ->
                _index = "doc/app/assets/js/index.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/app", (req, res) ->
                _index = "doc/app/assets/js/app.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/config", (req, res) ->
                _index = "doc/app/assets/js/config.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/auth-service", (req, res) ->
                _index = "doc/app/assets/js/auth-service.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/formulario-service", (req, res) ->
                _index = "doc/app/assets/js/formulario-service.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/boleto-service", (req, res) ->
                _index = "doc/app/assets/js/boleto-service.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/main-service", (req, res) ->
                _index = "doc/app/assets/js/main-service.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/main-ctrl", (req, res) ->
                _index = "doc/app/assets/js/main-ctrl.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/directives", (req, res) ->
                _index = "doc/app/assets/js/directives.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/run", (req, res) ->
                _index = "doc/app/assets/js/run.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/boot", (req, res) ->
                _index = "doc/app/assets/js/boot.html"
                res.sendFile _index, 'root':root
                
        @app.get "/docs/docco.css", (req, res) ->
                _index = "doc/app/assets/js/docco.css"
                res.sendFile _index, 'root':root
