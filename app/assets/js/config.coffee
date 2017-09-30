# Configure o motor que alimenta os cursos,
# seus pontos de acesso, templates baixados
# do servidor e o controlador que que gerencia
# coisas como o que aparece na tela e o que
# é executado pelo firebase
fetchConfig = ->
        log "Loading firebase config..."
        Vue.http.get("/config").then (config) ->
                if firebase.apps.length is 0 then firebase.initializeApp(config.data)
                config
        
                
                        # Primeiro inicialize as rotas angular
                                
                        for e in templates.data
                                obj = {template:e.template, controller: 'MainCtrl'}
                                $routeProvider.when(e.route,obj)
                                        
                        # Ponto inicial
                        $routeProvider.otherwise({redirectTo: '/'})

        
