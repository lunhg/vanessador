fetchRun = ->
        # A mensagem de carregamento inicial
        # deve ser atualizada
        loader = document.getElementById('masterLoader')
        p = loader.children[9]
        p.innerHTML =  "Verificando autorizações prévias"
        Run = ($rootScope, $http, $location, $route, $window) ->

                $rootScope.user = null
                $rootScope.typeformData = null
                $rootScope.registeredForms = null
                
                $rootScope.$on '$routeChangeSuccess', (event, next, current) ->
                        event.preventDefault();
                        console.log $location.url()   
                        
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
                        firebase.auth().onAuthStateChanged (user) -> if user then $rootScope.user = user
