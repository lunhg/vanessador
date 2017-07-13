# Aplicativo client
app = angular.module("vanessador", ["ngRoute", "ngResource"])

# Primeiro inicialize as rotas angular atraves
# de templates. Para recuperar esses templates, precisamos
# antes requerilos do servidor. Como n da p usar o
# modulo $http no .config, iremos usar XHR
app.config ($routeProvider, $locationProvider) ->
        xhr = new XMLHttpRequest()
        xhr.onreadystatechange = ->
                if (@readyState is 4 and @status is 200)
                        obj = JSON.parse xhr.responseText
                        $routeProvider.when("/", {
                                template: obj._index
                                controller: 'AuthCtrl'
                        }).when("/cursos", {
                                template: obj.cursos
                                controller: 'AuthCtrl'
                        }).when("/alunos", {
                                template : obj.alunos
                                controller: 'AuthCtrl'
                        }).when("/alunos/novo", {
                                template : obj.alunos_novo
                                controller: 'AuthCtrl'
                        }).otherwise({redirectTo: '/'})
                        $locationProvider.html5Mode(true)

        xhr.open('GET', '/templates', true)
        xhr.send()
        
# Controlador geral
# TODO Separar os controles    
onAuth = ($scope, $http) ->

        $scope.user = null
        $scope.iconGoogle = "https://cdn4.iconfinder.com/data/icons/new-google-logo-2015/400/new-google-favicon-16.png"

        # When user logged, update authData
        $http({
                method: 'GET',
                url: '/config'
        }).then (config) ->
                if not firebase.apps.length
                        firebase.initializeApp config.data            
                        
                firebase.auth().onAuthStateChanged (user) ->
                        if user
                                $scope.user = user
                                console.log user

        # 'Private' methods 
        onErr  = (err) ->  $scope.error = err
        onSignout = -> $scope.user= null

        # Durante o login do google
        $scope.loginGoogle = ->
                if not firebase.auth().currentUser
                        provider = new firebase.auth.GoogleAuthProvider()
                        provider.addScope('https://www.googleapis.com/auth/userinfo.profile')
                        firebase.auth().signInWithPopup(provider).then (result) ->
                                $http({
                                        method: 'POST'
                                        url: '/auth/callback?provider=google&uid=#{result.user.uid}&token=#{result.token}'
                                }).catch onErr


        # durante o logout
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

        $scope.onNovoAlunx = ->
                $http(method:'GET', url:'/genUUid')
                firebase.database().ref('alunos/').set({

                })
# Registre o controlador
app.controller "AuthCtrl", ['$scope', '$http', onAuth]

