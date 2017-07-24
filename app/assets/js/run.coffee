fetchRun = ->
        # A mensagem de carregamento inicial
        # deve ser atualizada
        loader = document.getElementById('masterLoader')
        p = loader.children[9]
        p.innerHTML =  "Verificando autorizações prévias"
        Run = ($rootScope, $http, $location, $route, $window) ->
        
                # Usuário atual
                $rootScope.user = null
                $rootScope.popup = null
                $rootScope.typeformData = null
                $rootScope.registeredForms = null
                $rootScope.dialogShown = false
                $rootScope.dialogMessage = "Nenhuma mensagem"

        
                # Historico de uso, para poder
                # atualizar corretamente as páginas
                # https://stackoverflow.com/questions/15175429/angularjs-getting-previous-route-path
                history = [];
        
                $rootScope.$on '$routeChangeSuccess', (event, next, current) ->
                        event.preventDefault();
                        console.log $location.url()   
                        history.push($location.$$path);
                
                        
                back = ->
                        prevUrl = if history.length > 1 then history.splice(-2)[0] else "/"
                        $location.path(prevUrl)
                        
                $rootScope.onLoading = true
                $rootScope.defaultPhotoURL = '/assets/images/vanessadora.png'
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
                                        
                                        # Notifique o usuário atual de qq mudança importante
                                        firebase.database()
                                                .ref("/users/#{user.uid}/popup")
                                                .once 'value', (snapshot) ->
                                                        val = snapshot.val()
                                                        if val
                                                                $rootScope.dialogMessage = snapshot.val()
                                                        else
                                                                $rootScope.dialogMessage = "Usuário deslogado"
                                                        $rootScope.dialogShown = not $rootScope.dialogShown

                                
                                
                                                
                        $rootScope.onLoading = false
