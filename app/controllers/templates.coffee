AppManager::templates = ->

        getTemplate = (p) ->
                new Promise (resolve, reject) ->
                        _p = path.resolve "#{path.join(__dirname)}/../app/views/#{p}.pug"
                        fs.readFile _p, 'utf8', (err, content) ->
                                if not err
                                        try
                                                opt = {filename: _p, doctype:'html'}
                                                html = pug.compile(content, opt)()
                                                result = component: {template: html}, name: p
                                                if p.match /_index/
                                                        result.path = "/"
                                                # GET /#/formularios/:uuid/stats
                                                # GET /#/formularios/:uuid/questions
                                                # GET /#/formularios/:uuid/responses
                                                else if p.match /^formularios_uuid_[a-z]+$/
                                                        r = p.split("_")
                                                        result.path = "/#{r[0]}/:uuid/#{r[2]}"

                                                # GET /#/formularios/:uuid/responses/:token
                                                else if p.match /^formularios_uuid_\w+_[a-z]+$/
                                                        r = p.split("_")
                                                        result.path = "/#{r[0]}/:uuid/#{r[2]}/:token"

                                                # GET /#/formularios/novo
                                                else if p.match /formularios_novo/
                                                        r = p.split("_")
                                                        result.path = "/#{r[0]}/novo"
        
                                                # GET /#/boletos/:invoiceid
                                                else if p.match /^boletos$/
                                                        result.path = "/boletos"
                        
                                                # GET /#/boletos/:invoiceid
                                                else if p.match /boletos_id/
                                                        r = p.split("_")
                                                        result.path = "/boletos/:invoiceid"

                                                # GET /#/conta/telefone/vincular
                                                else if p.match /^conta_\w+_\w+$/
                                                        r = p.split("_")
                                                        result.path = "/#{r[0]}/:option/:action"

                                                # GET /#/estudantes
                                                else if p.match /^estudantes$/
                                                        result.path = "/estudantes"
                                                        
                                                # GET /#/estudantes/:id
                                                else if p.match /^estudantes_id$/
                                                        result.path = "/estudantes/:id"

                                                # GET /#/cursos
                                                else if p.match /^cursos$/
                                                        result.path = "/cursos"
                                                        
                                                # GET /#/estudantes/:id
                                                else if p.match /^cursos_id$/
                                                        result.path = "/cursos/:id"
                                                        
                                                else 
                                                        result.path = "/#{p}"
                                                resolve result
                                        catch e
                                                console.log e
                                                reject e
                                else
                                        reject err
                   
        @app.get '/templates/:type', (req, res) ->
                onSuccess = (result) -> res.json result
                onErr = (err) -> res.json err.message
                getTemplate(req.params['type']).then(onSuccess).catch(onErr)
