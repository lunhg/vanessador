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
