fetchTypeform = ->
        # A mensagem de carregamento inicial
        # deve ser atualizada
        loader = document.getElementById('masterLoader')
        p = loader.children[9]
        p.innerHTML = "Trabalhando no typeform..."
        TypeformCtrl = ($rootScope, $http, $location, $window, $controller, toastr, formularioService, boletoService)->

                
                       
                                        

                        
                #angular.extend this, $controller('AuthCtrl', {$scope:$rootScope})
