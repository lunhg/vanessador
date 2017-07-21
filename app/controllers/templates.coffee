
                                        
AppManager::templates = ->

        getTemplate = (p) ->
                new Promise (resolve, reject) ->
                        _p = path.resolve "#{path.join(__dirname)}/../app/views/#{p}.pug"
                        fs.readFile _p, 'utf8', (err, content) ->
                                if not err
                                        try
                                                opt = {filename: _p, doctype:'html'}
                                                html = pug.compile(content, opt)()
                                                result = template: html, route: ( ->
                                                        if p.match /_index/
                                                                "/"
                                                        else if p.match /^\w+_uuid_[a-z]+$/
                                                                r = p.split("_")
                                                                "/#{r[0]}/:uuid/#{r[2]}"
                                                        else if p.match /^\w+_uuid_[a-z]+_\w+$/
                                                                r = p.split("_")
                                                                "/#{r[0]}/:uuid/#{r[2]}/:token"
                                                        else if p.match /\w+_novo/
                                                                r = p.split("_")
                                                                "/#{r[0]}/novo"
                                                        else
                                                                "/#{p}"
                                                )()
                                                resolve result
                                        catch e
                                                reject e
                                else
                                        reject err
                   
        @app.get '/templates', (req, res) ->
                onSuccess = (results) -> res.json results
                onErr = (err) -> res.json err.message
                
                Promise.all(getTemplate(template) for template in require("../package.json")['angular-templates']).then(onSuccess).catch(onErr) 
