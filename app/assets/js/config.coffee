# Configure o motor que alimenta os cursos,
# seus pontos de acesso, templates baixados
# do servidor e o controlador que que gerencia
# coisas como o que aparece na tela e o que
# é executado pelo firebase
fetchConfig = ->
        console.log "Configurando templates..."
        $http.get('/templates').then (templates) ->
                app.config ($routeProvider, $locationProvider) ->
        
                        # Primeiro inicialize as rotas angular
                        for e in templates.data
                                $routeProvider.when(e.route,{template:e.template,controller:'AuthCtrl'}) 

                        # Ponto inicial
                        $routeProvider.otherwise({redirectTo: '/'})
        
                        # Habilite HTML5
                        $locationProvider.html5Mode(enabled:true)
                
