AppManager::typeform = ->
        @app.get '/typeform/data-api', (req, res) ->
                projectName = require("#{path.join(__dirname)}/../package.json").firebase.project.name
                pwd = "#{projectName}.typeform.apiKey"
                console.log "Search for  #{pwd}"
                keytar.findPassword(pwd)
                        .then (apiKey) ->
                                _url = "form/#{req.query.uuid}?key=#{apiKey}"
                                _url += "&completed=true"
                                onGet = (err, _res, body) ->
                                        if err
                                                res.json err
                                        else
                                                console.log body
                                                res.json body
                                request_json.createClient('https://api.typeform.com/v1/').get(_url,onGet) 
                        .catch (err) ->
                                res.json err

        @app.scheduler =
                count: 1
                rule: new node_schedule.RecurrenceRule()
                
        @app.get '/typeform/scheduller/activate', (req, res) ->
                
                @app.scheduler.rule.second = new node_schedule.Range(0, 59, parseFloat(req.query.time));
                @app.scheduler.scheduleJob rule, ->
                        request_json.createClient('https://localhost:3001')
                                .get("/typeform/data-api?uuid=#{req.query.uuid}")
                                .then (result) ->
                                        _app.scheduler.count += 1
                                .catch (err) ->
                                        console.log err

                
        @app.get '/typeform/scheduller/deactivate', (req, res) ->
