AppManager::templates = ->
        getTemplate = (p) ->
                new Promise (resolve, reject) ->
                        _p = "#{path.join(__dirname)}/../app/views/#{p}.pug"
                        fs.readFile _p, 'utf8', (err, content) ->
                                if not err
                                        resolve ["#{p}", pug.compile(content, {filename: _p, doctype:'html'})()]
                                else
                                        reject err

                                        
        @app.get '/templates', (req, res) ->
                a = []
                a.push getTemplate(p) for p in ['_index', 'login', 'signup', 'resetPassword', 'confirmResetPassword']
                Promise.all(a).then (results) ->
                        json = {}
                        json[p[0]] = p[1] for p in results
                        res.json json
