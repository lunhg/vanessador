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
                        $routeProvider.when("/", {template: obj._index, controller: 'AuthCtrl'})
                                .when("/login", {template: obj.login, controller: 'AuthCtrl'})
                                .when("/signup", {template: obj.signup, controller: 'AuthCtrl'})
                                .when("/resetPassword", {template: obj.resetPassword, controller: 'AuthCtrl'})
                                .when("/confirmResetPassword", {template: obj.confirmResetPassword, controller: 'AuthCtrl'})
                                #.when("/:uuid/cursos", {template: obj.uuid_cursos, controller: 'AuthCtrl'})
                                #.when("/cursos/novo", {template: obj.cursos_novo, controller: 'AuthCtrl'})
                                #.when("/:uuid/cursos/:uid", {template: obj.uuid_cursos_uuid, controller: 'AuthCtrl'})
                                .when("/:uuid/alunos", {template : obj.alunos, controller: 'AuthCtrl'})
                                #.when("/:uuid/alunos/novo", {template : obj.alunos_novo, controller: 'AuthCtrl'})
                                .otherwise({redirectTo: '/'})

                        # Habilite HTML5
                        $locationProvider.html5Mode(true)
        xhr.open('GET', '/templates', true)
        xhr.send()
