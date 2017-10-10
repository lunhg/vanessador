AppManager::typeform = ->
        @app.get '/typeform/data-api', (req, res) ->
                dotenv.config()
                _url = "form/#{req.query.uuid}?key=#{process.env.TYPEFORM_API_KEY}"
                _url += "&completed=true"
                onGet = (err, _res, body) -> if err then res.json err else res.json body
                request_json.createClient('https://api.typeform.com/v1/').get(_url,onGet)
