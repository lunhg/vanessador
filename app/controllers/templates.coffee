
                                        
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
                                                # No angular isso cria rotas através
                                                # dos hashbangs (onde /#!/ é a página inicial)
                                                #
                                                # GET /#!/
                                                if p.match /_index/
                                                        result.controller = 'AuthCtrl'
                                                        result.route = "/"

                                                # GET /#!/formularios/:uuid/stats
                                                # GET /#!/formularios/:uuid/questions
                                                # GET /#!/formularios/:uuid/responses
                                                else if p.match /^formularios_uuid_[a-z]+$/
                                                        result.controller = 'TypeformCtrl'
                                                        r = p.split("_")
                                                        result.route = "/#{r[0]}/:uuid/#{r[2]}"

                                                # GET /#!/formularios/:uuid/responses/:token
                                                else if p.match /^formularios_uuid_\w+_[a-z]+$/
                                                        result.controller = 'TypeformCtrl'
                                                        r = p.split("_")
                                                        result.route = "/#{r[0]}/:uuid/#{r[2]}/:token"

                                                # GET /#!/formularios/novo
                                                else if p.match /formularios_novo/
                                                        result.controller = 'TypeformCtrl'
                                                        r = p.split("_")
                                                        result.route = "/#{r[0]}/novo"

                                                # GET /#!/boletos/:invoiceid
                                                else if p.match /boletos_id/
                                                        result.controller = 'PaypalCtrl'
                                                        r = p.split("_")
                                                        result.route = "/boletos/:invoiceid"

                                                # GET otherwise
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
