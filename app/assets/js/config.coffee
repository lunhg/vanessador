# Configure o motor que alimenta os cursos,
# seus pontos de acesso, templates baixados
# do servidor e o controlador que que gerencia
# coisas como o que aparece na tela e o que
# é executado pelo firebase
app.config ($routeProvider, $locationProvider) ->
        
        # Primeiro inicialize as rotas angular atraves
        # de templates. Para recuperar esses templates, precisamos
        # antes requerilos do servidor. Como n da p usar o
        # modulo $http no .config, iremos usar XHR.
        
        xhr = new XMLHttpRequest()
        xhr.onreadystatechange = ->
                if @readyState is 4 and @status is 200
                        obj = JSON.parse xhr.responseText

                        # Cada ponto é nomeado por um template e controlador
                        for e in obj
                                console.log e
                                $routeProvider.when(e.route,{template:e.template,controller:'AuthCtrl'}) 

                        # Ponto inicial
                        $routeProvider.otherwise({redirectTo: '/'})

                        # Habilite HTML5
                        $locationProvider.html5Mode(true)

        # /templates é a rota contendo o
        # compilador pug.js que cria
        # os templates para as rotas angular
        xhr.open('GET', '/templates', true)
        xhr.send()
