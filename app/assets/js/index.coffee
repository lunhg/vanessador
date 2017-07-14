# Aplicativo client
app = angular.module("vanessador", ["ngRoute", "ngResource"])


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
                                .when("/cursos", {template: obj.cursos, controller: 'AuthCtrl'})
                                #.when("/:uuid/cursos", {template: obj.uuid_cursos, controller: 'AuthCtrl'})
                                #.when("/:uuid/cursos/novo", {template: obj.uuid_cursos_novo, controller: 'AuthCtrl'})
                                #.when("/:uuid/cursos/:uid", {template: obj.uuid_cursos_uuid, controller: 'AuthCtrl'})
                                .when("/:uuid/alunos", {template : obj.alunos, controller: 'AuthCtrl'})
                                #.when("/:uuid/alunos/novo", {template : obj.alunos_novo, controller: 'AuthCtrl'})
                                .otherwise({redirectTo: '/'})

                        # Habilite HTML5
                        $locationProvider.html5Mode(true)
        xhr.open('GET', '/templates', true)
        xhr.send()



# Controlador de autenticacao
# TODO Separar os controles    
onAuth = ($scope, $http) ->

        # Usuário atual
        $scope.user = null

        # Atualize a configuração do firebase
        $http({
                method: 'GET',
                url: '/config'
        }).then (config) ->
                if not firebase.apps.length then firebase.initializeApp config.data            
                
                # Somente após reconhecer o login,
                # o usuário é carregado e a página muda
                # alguns elementos
                firebase.auth().onAuthStateChanged (user) ->
                        if user
                                $scope.user = user
                                console.log user

        
        # 'Private' methods 
        onErr  = (err) ->  $scope.error = err
        onSignout = -> $scope.user= null
        onLogin = (result) ->
                $http({
                        method: 'POST'
                        url: '/auth/callback?provider=google&uid=#{result.user.uid}&token=#{result.token}'
                }).catch onErr

        # Login Google
        # realizado com o firebase
        # TODO Importante retornar ao servidor
        # uma indicação de que tipo de login foi feito 
        $scope.loginGoogle = ->
                if not firebase.auth().currentUser
                        provider = new firebase.auth.GoogleAuthProvider()
                        provider.addScope('https://www.googleapis.com/auth/userinfo.profile')
                        firebase.auth().signInWithPopup(provider).then(onLogin)

        $scope.loginEmailAndPassword = ->
                if not firebase.auth().currentUser
                        regexp = /^\w+@itsrio.org$/
                        email = document.getElementById('input_login_email').value
                        if email.match regexp then firebase.auth().signInWithEmailAndPassword(email, (document.getElementById('input_login_password').value)).catch (err) -> alert err.message else alert "Seu email não é @itsrio.org"
        

        $scope.createUserWithEmailAndPassword = ->
                if not firebase.auth().currentUser
                        email = document.getElementById('input_login_email').value
                        if email.match regexp then firebase.auth().createUserWithEmailAndPassword(email, (document.getElementById('input_login_password').value)).catch (err) -> alert err.message

        # callback para o logout
        $scope.logout = -> firebase.auth().signOut().then(onSignout).catch(onErr)

        # Para o menu funcionar corretamente com o bootstrap
        # Vamos adicionar as interações
        dropping = false
        $scope.onDropmenu = (what)->
                if not dropping
                        document.getElementById(what).classList.add('open')
                        document.getElementById(what).setAttribute('aria-expanded', 'true')
                        dropping = true
                else
                        document.getElementById(what).classList.remove('open')
                        document.getElementById(what).setAttribute('aria-expanded', 'false')
                        dropping = false

        # icone de loading
        $scope.onLoading = false

        # Dados typeform
        $scope.typeformData = null
        $scope.searchForm = (options)->
                $scope.onLoading = true
                query = []
                search = document.getElementById("input_typeform_uuid")
                $scope.lastUuid = search.value or search.getAttribute('placeholder')
                query.push "uuid=#{$scope.lastUuid}"
                query.push "#{k}=#{v}" for k,v of options
                $http({
                        method: 'GET',
                        url: "/typeform/data-api?#{query.join('&')}"
                }).then (response) ->
                        $scope.onLoading = false
                        console.log response.data
                        $scope.typeformData = response.data

        $scope.onNovo = (ref, obj) -> firebase.database().ref(ref).set(obj)
        
# Registre o controlador
app.controller "AuthCtrl", ['$scope', '$http', onAuth]

