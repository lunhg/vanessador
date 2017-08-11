#request.debug = true 
PagSeguroSDK = 

        config: ->
                new Promise (resolve, reject) ->
                        p = require('../package.json').firebase.project.name
                        Promise.all([
                                keytar.findPassword("#{p}.pagseguro.email")
                                keytar.findPassword("#{p}.pagseguro.apiKey")
                        ]).then (results) ->
                                resolve {email:results[0], token: results[1]}
                        .catch reject

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
                                json.receiver = email: results.email
                                PagSeguroSDK.toXML(json).then (xml) ->
                                        console.log xml
                                        baseurl = "https://ws.sandbox.pagseguro.uol.com.br/v2#{action}"
                                        query = "?email=#{results.email}&token=#{results.token}"
                                        _request =
                                                method: 'POST'
                                                url: baseurl+query
                                                body: xml
                                                headers: {'Content-Type':'application/xml'}
                                        onPost =  (err, response, body) ->
                                                if err then resolve err.message
                                                if not err then resolve body
                                        request(_request, onPost)


        get: (action, json) ->
                self = this
                new Promise (resolve, reject) ->
                        PagSeguroSDK.config().then (result) ->
                                baseurl = "https://ws.sandbox.pagseguro.uol.com.br/v2#{action}"
                                query = "?email=#{result.email}&token=#{result.token}"
                                _request =
                                        method: 'GET'
                                        url: baseurl+query
                                        headers: {'Content-Type':'application/xml'}
                                onGet =  (err, response, body) ->
                                        if err then resolve err.message
                                        if not err then resolve body
                                request _request, onGet


        put: (action, json) ->
                self = this
                new Promise (resolve, reject) ->
                        PagSeguroSDK.config().then (result) ->
                                url = "https://ws.sandbox.pagseguro.uol.com.br/v2#{action}?email=#{result.email}&token=#{result.token}"
                                PagSeguro.toXML(json).then (xml) ->
                                        baseurl = "https://ws.sandbox.pagseguro.uol.com.br/v2#{action}"
                                        query = "?email=#{results.email}&token=#{results.token}"
                                        _request =
                                                method: 'PUT'
                                                url: baseurl+query
                                                body: xml
                                                headers: {'Content-Type':'application/xml'}
                                        onPut =  (err, response, body) ->
                                                if err then resolve err.message
                                                if not err then resolve body
                                request(_request, onPut)
