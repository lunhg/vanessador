# Configure o motor que alimenta os cursos,
# seus pontos de acesso, templates baixados
# do servidor e o controlador que que gerencia
# coisas como o que aparece na tela e o que
# é executado pelo firebase
fetchConfig = ->
        # A mensagem de carregamento inicial
        # deve ser atualizada
        loader = document.getElementById('masterLoader')
        p = loader.children[9]
        p.innerHTML =  "Configurando templates..."
        angular.injector(["ng"]).get("$http").get('/templates').then (templates) ->
                app.config ($routeProvider, $locationProvider) ->
        
                        # Primeiro inicialize as rotas angular
                        
                        for e in templates.data
                                obj = {template:e.template, controller: 'MainCtrl'}
                                $routeProvider.when(e.route,obj)
                        # Ponto inicial
                        $routeProvider.otherwise({redirectTo: '/'})
        
                        # Habilite HTML5 com hashbang
                        # https://stackoverflow.com/questions/16677528/location-switching-between-html5-and-hashbang-mode-link-rewriting#16678065
                        $locationProvider.html5Mode(enabled:false).hashPrefix "!"
                
