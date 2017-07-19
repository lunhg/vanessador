AppManager::services = ->

        getTemplate = (p) ->
                new Promise (resolve, reject) ->
                        _p = path.resolve "#{path.join(__dirname)}/../app/views/#{p}.pug"
                        fs.readFile _p, 'utf8', (err, content) ->
                                if not err
                                        try
                                                opt = {filename: _p, doctype:'html'}
                                                if p is 'dialog'
                                                        resolve {restrict: 'E',scope: { show: '='},replace: true,transclude: true,template: pug.compile(content, opt)()}
                                                else
                                                        reject new Error("#{p} isnt a valid service")
                                        catch e
                                                reject e
                                else
                                        reject err
        @app.get '/services', (req, res) ->
                onSuccess = (result) -> res.json result
                onErr = (err) -> res.json err 
                getTemplate(req.query['q']).then(onSuccess).catch(onErr)
