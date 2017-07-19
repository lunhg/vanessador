Run = ($rootScope, $http, $location, $route, $window) ->
        
        # Usuário atual
        $rootScope.user = null
        $rootScope.popup = null
        $rootScope.typeformData = null
        $rootScope.onLoading = false
        $rootScope.nextRoute = null
        $rootScope.registeredForms = null

        # Historico de uso, para poder
        # atualizar corretamente as páginas
        # https://stackoverflow.com/questions/15175429/angularjs-getting-previous-route-path
        history = [];

        $rootScope.$on '$routeChangeSuccess', -> history.push($location.$$path);
                
        $rootScope.back = ->
                prevUrl = if history.length > 1 then history.splice(-2)[0] else "/"
                $location.path(prevUrl)
        
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
                
                                # Envie um email de verificação se o usuário
                                # ainda não foi verificado, no caso de cadastro
                                # por email e senha
                                if not user.emailVerified then user.sendEmailVerification()

                # atualize a base de dados
                # conforme ela for populada
                firebase.database().ref('formularios/').on 'value', (snapshot) ->
                        $rootScope.registeredForms = snapshot.val()

        # Inicie o aplicativo
        $rootScope.nextRoute = $rootScope.back() or "/login"
        $location.path($rootScope.nextRoute)
        $route.reload()

app.run(['$rootScope', '$http', '$location', '$route', '$window', Run])
