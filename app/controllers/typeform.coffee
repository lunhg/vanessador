AppManager::typeform = ->
        @app.get '/typeform/data-api', (req, res) ->
                projectName = require("#{path.join(__dirname)}/../package.json").firebase.project.name
                pwd = "#{projectName}.typeform.apiKey"
                console.log "Search for  #{pwd}"
                keytar.findPassword(pwd).then (apiKey) ->
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
