AppManager::services = ->

        getTemplate = (p) ->
                new Promise (resolve, reject) ->
                        _p = path.resolve "#{path.join(__dirname)}/../app/views/#{p}.pug"
                        fs.readFile _p, 'utf8', (err, content) ->
                                if not err
                                        html = pug.compile(content, {filename:_p,doctype:'html'})()
                                        resolve {
                                                name: p
                                                options: {
                                                        restrict: 'A'
                                                        template: html
                                                        replace: true
                                                        transclude: true
                                                }
                                        }
                                else
                                        reject err

        _on = (what) ->
                a = []
                for w in require("../package.json")["angular-#{what}"]
                        a.push getTemplate(w) 
                Promise.all(a)

        @app.get "/services", (req, res) ->
                onSuccess = (result) -> res.json result
                onErr = (err) -> res.json err
                _on('services').then(onSuccess).catch(onErr)
                
        @app.get "/directives", (req, res) ->
                onSuccess = (result) -> res.json result
                onErr = (err) -> res.json err
                _on('directives').then(onSuccess).catch(onErr)
