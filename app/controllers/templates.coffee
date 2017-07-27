
                                        
AppManager::templates = ->

        getTemplate = (p) ->
                new Promise (resolve, reject) ->
                        _p = path.resolve "#{path.join(__dirname)}/../app/views/#{p}.pug"
                        fs.readFile _p, 'utf8', (err, content) ->
                                if not err
                                        try
                                                opt = {filename: _p, doctype:'html'}
                                                html = pug.compile(content, opt)()
                                                result = template: html, controller:'', route: ''
                                                if p.match /_index/
                                                        result.controller = 'AuthCtrl'
                                                        result.route = "/"
                                                else if p.match /^formularios_uuid_[a-z]+$/
                                                        result.controller = 'TypeformCtrl'
                                                        r = p.split("_")
                                                        result.route = "/#{r[0]}/:uuid/#{r[2]}"
                                                else if p.match /^formularios_uuid_[a-z]+_\w+$/
                                                        result.controller = 'TypeformCtrl'
                                                        r = p.split("_")
                                                        result.route = "/#{r[0]}/:uuid/#{r[2]}/:token"
                                                else if p.match /formularios_novo/
                                                        result.controller = 'TypeformCtrl'
                                                        r = p.split("_")
                                                        result.route = "/#{r[0]}/novo"
                                                else if p.match /boletos_token/
                                                        result.controller = 'PaypalCtrl'
                                                        r = p.split("_")
                                                        result.route = "/boletos/:token"
                                                else
                                                        result.controller = 'AuthCtrl'
                                                        result.route = "/#{p}"
                                                
                                                console.log result
                                                resolve result
                                        catch e
                                                console.log e
                                                reject e
                                else
                                        reject err
                   
        @app.get '/templates', (req, res) ->
                onSuccess = (results) -> res.json results
                onErr = (err) -> res.json err.message
                
                Promise.all(getTemplate(template) for template in require("../package.json")['angular-templates']).then(onSuccess).catch(onErr) 
