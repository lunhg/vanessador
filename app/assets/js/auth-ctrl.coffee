# Controlador de autenticacao
# TODO Separar os controles    
fetchAuthCtrl = ->
        # A mensagem de carregamento inicial
        # deve ser atualizada
        loader = document.getElementById('masterLoader')
        p = loader.children[9]
        p.innerHTML = "Trabalhando na autorização..."
        AuthCtrl = ($rootScope, $http, $location, $window, $route, ) ->

                

                
                
        new Promise (resolve) -> resolve AuthCtrl
                
