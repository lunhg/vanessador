#request.debug = true 
PagSeguroSDK = 

        config: ->
                new Promise (resolve, reject) ->
                        p = require('../package.json').firebase.project.name
                        try
                                resolve {
                                        email:process.env.APIS_EMAIL,
                                        token: process.env.PAGSEGURO_TOKEN
                                }
                        catch e
                                reject e

        toXML: (json) ->
                
                new Promise (resolve, reject) ->
                        hasParent = {}
                        xml = xmlbuilder.create('root')
                        build = (el, data) ->
                                for k,v of data
                                        if typeof v is 'object'
                                                _el = el.ele(k)
                                                build(_el, v)
                                        else
                                                el.ele(k, v)                        

                        build xml, json
                        _xml = xml.toString()
                        _xml = _xml.replace(/<root>/, "<?xml version='1.0' encoding='UTF-8'?>")
                        _xml = _xml.replace(/undefined/, "")
                        _xml = _xml.replace(/<\/root>/, "")
                        resolve  _xml
                                                
        post: (action, json) ->
                self = this
                new Promise (resolve, reject) ->
                        PagSeguroSDK.config().then (results) ->
                                baseurl = "https://ws.sandbox.pagseguro.uol.com.br/v2#{action}/?"
                                baseurl += "&email=#{results.email}"
                                baseurl += "&token=#{results.token}"
                                _request =
                                        method: 'POST'
                                        url: baseurl
                                        headers: {'Content-Type':'application/xml'}
                                PagSeguroSDK.toXML(json or {}).then (xml) ->
                                        console.log xml
                                        _request.body = xml
                                        onPost =  (err, response, body) ->
                                                console.log body
                                                if err then resolve err.message
                                                if not err then resolve body
                                        request(_request, onPost)


        get: (action, json) ->
                self = this
                new Promise (resolve, reject) ->
                        PagSeguroSDK.config().then (result) ->
                                json.email = results.email
                                json.token = results.token
                                PagSeguroSDK.toXML(json).then (xml) ->
                                        baseurl = "https://ws.sandbox.pagseguro.uol.com.br/v2#{action}"
                                        _request =
                                                method: 'GET'
                                                url: baseurl
                                                headers: {'Content-Type':'application/xml'}
                                        onGet =  (err, response, body) ->
                                                if err then resolve err.message
                                                if not err then resolve body
                                        request _request, onGet
