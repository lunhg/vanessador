AppManager::docs = ->

        root = path.resolve "#{path.join(__dirname)}/../app/assets"

        @app.get "/docs/client/index", (req, res) ->
                _index = "doc/app/assets/js/index.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/client/app", (req, res) ->
                _index = "doc/app/assets/js/app.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/client/config", (req, res) ->
                _index = "doc/app/assets/js/config.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/client/auth-ctrl", (req, res) ->
                _index = "doc/app/assets/js/auth-ctrl.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/client/run", (req, res) ->
                _index = "doc/app/assets/js/run.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/client/services", (req, res) ->
                _index = "doc/app/assets/js/services.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/client/docco.css", (req, res) ->
                _index = "doc/app/assets/js/docco.css"
                res.sendFile _index, 'root':root
                
        @app.get "/docs/client/index", (req, res) ->
                _index = "doc/app/assets/js/index.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/client/app", (req, res) ->
                _index = "doc/app/assets/js/app.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/client/config", (req, res) ->
                _index = "doc/app/assets/js/config.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/client/auth-ctrl", (req, res) ->
                _index = "doc/app/assets/js/auth-ctrl.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/client/run", (req, res) ->
                _index = "doc/app/assets/js/run.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/client/services", (req, res) ->
                _index = "doc/app/assets/js/services.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/client/docco.css", (req, res) ->
                _index = "doc/app/assets/js/docco.css"
                res.sendFile _index, 'root':root

        #################

        @app.get "/docs/server/config/app", (req, res) ->
                _index = "doc/config/app.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/server/config/server", (req, res) ->
                _index = "doc/config/server.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/server/config/paypal", (req, res) ->
                _index = "doc/config/paypal.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/server/config/pagseguro", (req, res) ->
                _index = "doc/config/pagseguro.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/server/config/docco.css", (req, res) ->
                _index = "doc/config/docco.css"
                res.sendFile _index, 'root':root
