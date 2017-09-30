AppManager::docs = ->

        root = path.resolve "#{path.join(__dirname)}/../app/assets"
                                        
        @app.get "/docs/:folder/:file", (req, res) ->
                _index = "doc/#{req.params['folder']}/#{req.params['file']}.html"
                res.sendFile _index, 'root':root

        # Doc config/
        @app.get "/docs/server/config/environment", (req, res) ->
                _index = "doc/config/environment.html"
                res.sendFile _index, 'root':root
                
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

        # Doc boot/
        @app.get "/docs/server/boot/dependencies", (req, res) ->
                _index = "doc/boot/dependencies.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/server/boot/devDependencies", (req, res) ->
                _index = "doc/boot/devDependencies.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/server/boot/app", (req, res) ->
                _index = "doc/boot/app.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/server/boot/server", (req, res) ->
                _index = "doc/boot/server.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/server/boot/docco.css", (req, res) ->
                _index = "doc/boot/docco.css"
                res.sendFile _index, 'root':root


        # Doc app/controllers/

        @app.get "/docs/server/app/controllers/config", (req, res) ->
                _index = "doc/app/controllers/config.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/server/app/controllers/docs", (req, res) ->
                _index = "doc/app/controllers/docs.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/server/app/controllers/index", (req, res) ->
                _index = "doc/app/controllers/index.html"
                res.sendFile _index, 'root':root
                
        @app.get "/docs/server/app/controllers/pagseguro", (req, res) ->
                _index = "doc/app/controllers/pagseguro.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/server/app/controllers/paypal", (req, res) ->
                _index = "doc/app/controllers/paypal.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/server/app/controllers/services", (req, res) ->
                _index = "doc/app/controllers/services.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/server/app/controllers/templates", (req, res) ->
                _index = "doc/app/controllers/templates.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/server/app/controllers/typeform", (req, res) ->
                _index = "doc/app/controllers/typeform.html"
                res.sendFile _index, 'root':root

        @app.get "/docs/server/app/controllers/docco.css", (req, res) ->
                _index = "doc/app/controllers/docco.css"
                res.sendFile _index, 'root':root
