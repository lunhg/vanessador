fetchPaypal= ->
        # A mensagem de carregamento inicial
        # deve ser atualizada
        loader = document.getElementById('masterLoader')
        p = loader.children[9]
        p.innerHTML = "Trabalhando no paypal..."
        PaypalCtrl = ($rootScope, $http, $location, $window, $controller, toastr, boletoService)->

                onErr  = (err) -> toastr.error(err.code, err.message)                    

                $rootScope.onNovo = (options) ->
                        _onNovo = (result) ->
                                toastr.info("Boleto", "Boleto #{result.payment_id} gerado")
                                $window.reload()
                        boletoService.novo(firebase.auth().currentUser.uid, options).then(_onNovo).catch(onErr)

                
                $rootScope.onSend = (pid) ->
                        _onSend = (result) ->
                                toastr.info("Boleto", "Boleto #{result.payment_id} enviado para #{result.email}")
                                $window.reload()
                        user = firebase.auth().currentUser
                        boletoService.send(user.uid, pid).then(_onSend).catch(onErr)
                        
                $rootScope.onCancel = (pid) ->
                        _onSend = (result) ->
                                toastr.info("Boleto", "Boleto #{result.payment_id} cancelado")
                                $window.reload()
                        user = firebase.auth().currentUser
                        boletoService.send(user.uid, pid).then(_onSend).catch(onErr)
                                
                # Fake listeners para atualizar
                # os formulários typeform
                # em rotas específicas como
                # - /formularios/:uuid/:action
                #if  $location.url().match /^\/boletos\/\w+$/
                #        boletoService.getAll().then (boletos) ->

                #angular.extend this, $controller('AuthCtrl', {$scope:$rootScope})
