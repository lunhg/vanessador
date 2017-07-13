AppManager::index = ->
        @app.get '/', (req, res) ->
                res.render 'index'

        @app.get '/config', (req, res) ->
                projectName = require("#{path.join(__dirname)}/../package.json").firebase.project.name
                keytar.findPassword("#{projectName}.firebase.apiKey")
                        .then (apiKey) ->
                                keytar.findPassword("#{projectName}.firebase.messagingSenderId")
                                        .then (messagingSenderId) ->
                                                res.json
                                                        apiKey: apiKey,
                                                        authDomain: "#{projectName}.firebaseapp.com",
                                                        databaseURL: "https://#{projectName}.firebaseio.com",
                                                        projectId: projectName,
                                                        storageBucket: "#{projectName}.appspot.com",
                                                        messagingSenderId: messagingSenderId

        @app.get '/typeform/data-api', (req, res) ->
                projectName = require("#{path.join(__dirname)}/../package.json").firebase.project.name
                pwd = "#{projectName}.typeform.apiKey"
                console.log "Search for  #{pwd}"
                keytar.findPassword(pwd)
                        .then (apiKey) ->
                                _url = "form/#{req.query.uuid}?key=#{apiKey}"
                                _url += "&completed=#{req.query.completed}"
                                _url += "&limit=#{req.query.limit}"
                                onGet = (err, _res, body) ->
                                        if(err)
                                                res.json err
                                        else
                                                console.log body
                                                res.json body
                                request_json.createClient('https://api.typeform.com/v1/').get(_url,onGet) 
                        .catch (err) ->
                                res.json err

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
                a.push getTemplate(p) for p in ['_index', 'cursos', 'alunos', 'alunos_novo']
                Promise.all(a).then (results) ->
                        json = {}
                        json[p[0]] = p[1] for p in results
                        res.json json
