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



# Controlador de autenticacao
# TODO Separar os controles    
onAuth = ($rootScope, $http, $location) ->
        
        # 'Private' methods 
        onErr  = (err) ->  $rootScope.popup = "Error #{err.code}: #{err.message}"
        onSignout = -> $rootScope.user= null
        onLogin = (result) -> $location.path( "/" )

        # Login Google
        # realizado com o firebase
        # TODO Importante retornar ao servidor
        # uma indicação de que tipo de login foi feito 
        $rootScope.loginGoogle = ->
                if not firebase.auth().currentUser
                        provider = new firebase.auth.GoogleAuthProvider()
                        provider.addScope('https://www.googleapis.com/auth/userinfo.profile')
                        firebase.auth().signInWithPopup(provider).then(onLogin)

        $rootScope.loginEmailAndPassword = ->
                if not firebase.auth().currentUser
                        # check email domain
                        email = document.getElementById('input_login_email').value
                        if email.match /\w+@itsrio.org/ or email.match /gcravista@gmail.com/
                                firebase.auth()
                                        .signInWithEmailAndPassword(email,
                                                (document.getElementById('input_login_password').value)
                                        ).then ->
                                                $rootScope.popUp
                                        .catch(onErr) 

        # A random password generator
        randomPassword = (n) ->
                c = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!?_-'.split ''
                (c[Math.floor(Math.random() * c.length)] for i in [0..n-1]).join('')

        # Cheque o domínio do email (@itsrio.org)
        # Crie o usuário se for permitido
        # Envie um email resetando a senha
        $rootScope.createUserWithEmailAndPassword = ->
                if not firebase.auth().currentUser
                        # check email domain
                        email = document.getElementById('input_login_email').value
                        for reg in [
                                new RegExp "\w+@itsrio.org"
                                new RegExp "gcravista@gmail.com"
                        ]
                        
                                if email.match reg
                                        # Create the user
                                        firebase.auth()
                                                .createUserWithEmailAndPassword(email, randomPassword(16))
                                                .catch(onErr)
                        
        $rootScope.resetPassword = ->
                email = document.getElementById('reset_login_email').value
                firebase.auth().sendPasswordResetEmail(email)
                        .then ->
                                $rootScope.popup =
                                        msg: "Enviamos um email de confirmação para #{email}"
                                        type: 'success'
                                
                        .catch(onErr)

        onConfirmReset = (config) ->
                if query.apiKey is config.apiKey
                        firebase.auth()
                                .applyActionCode(query.oobCode)
                                .then (data) ->
                                        console.log data
                                        user = data.user.uid
                                        p1 = document.getElementById('reset_login_password').value
                                        p2 = document.getElementById('reset_login_password_confirm').value

                                        if p1 is p2
                                                user.updatePassword(p1)
                                                        .then ->
                                                                credential = firebase.auth()
                                                                        .EmailAuthProvider
                                                                        .credential(user.email, p1)
                                                                firebase.auth()
                                                                        .reautenticate(credential)
                                                                        .then onConfirm
                                                                        .catch onErr
                                                
                                                        .catch(onErr)
                                        else
                                                $rootScope.popup =
                                                        msg: "Sua senha de confirmação não é igual a primeira"
                                                        type: "danger"
                else
                        console.log 'apiKey incorrect'
                        
        $rootScope.confirmResetPassword = ->
                query = $location.search('mode', 'oobCode', 'apiKey')
                console.log query
                onConfirm = ->
                        $rootScope.popup =
                                msg: 'Senha redefinida com sucesso'
                                type: 'success'
                                
                if query.mode is 'resetPassword' and query.oobCode
                        $http({
                                method: 'GET',
                                url: '/config'
                        }).then(onReset).catch(onErr)
        
        # callback para o logout
        $rootScope.logout = ->
                firebase.auth().signOut().then(onSignout).catch(onErr)
                
        # Para o menu funcionar corretamente com o bootstrap
        # Vamos adicionar as interações
        dropping = false
        $rootScope.onDropmenu = (what)->
                if not dropping
                        document.getElementById(what).classList.add('open')
                        document.getElementById(what).setAttribute('aria-expanded', 'true')
                        dropping = true
                else
                        document.getElementById(what).classList.remove('open')
                        document.getElementById(what).setAttribute('aria-expanded', 'false')
                        dropping = false

        # icone de loading
        $rootScope.onLoading = false

        # Dados typeform
        $rootScope.typeformData = null
        $rootScope.searchForm = (id, options)->
                $rootScope.onLoading = true
                query = []
                search = document.getElementById(id)
                t = if search.value isnt '' then search.value else search.getAttribute('placeholder')
                console.log t
                query.push "uuid=#{t}"
                query.push "#{k}=#{v}" for k,v of options
                _url = "/typeform/data-api?#{query.join('&')}"
                console.log _url
                $http({
                        method: 'GET',
                        url: _url
                }).then (response) ->
                        $rootScope.onLoading = false
                        console.log response.data
                        $rootScope.typeformData = response.data

        $rootScope.novo = (ref, obj) ->
                id = randomPassword(6)
                firebase.database().ref("/#{firebase.auth().currentUser}/cursos/#{id}").set(obj)
        
# Registre o controlador
app.controller "AuthCtrl", ['$rootScope', '$http', '$location', onAuth]
app.run(['$rootScope', '$http', '$location', ($rootScope, $http, $location) ->
        
        # Usuário atual
        $rootScope.user = null
        $rootScope.popup = null
        $rootScope.typeformData = null
        
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
                                $rootScope.user = user
                                $rootScope.popup =
                                        msg: "Bem vindo #{user.displayName}"
                                        type: 'success'
                $location.path("/")
])
