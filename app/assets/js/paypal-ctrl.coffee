fetchPaypal= ->
        # A mensagem de carregamento inicial
        # deve ser atualizada
        loader = document.getElementById('masterLoader')
        p = loader.children[9]
        p.innerHTML = "Trabalhando no paypal..."
        PaypalCtrl = ($rootScope, $http, $location, $window, $controller, toastr, boletoService)->

                onErr  = (err) -> toastr.error(err.code, err.message)                    

                
                $rootScope.onSend = ->
                        user = firebase.auth().currentUser
                        token = $rootScope.boleto.token
                        id = $rootScope.boleto.invoice
                        _onSend = (result)->
                                toastr.info("Boleto", "Boleto #{id} enviado")
                        
                        boletoService.send(user.uid, token, id).then(_onSend).catch(onErr)
                        
                $rootScope.onCancel = ->
                        _onSend = (result) ->
                                toastr.info("Boleto", "Boleto #{result.payment_id} cancelado")
                        user = firebase.auth().currentUser
                        boletoService.cancel(user.uid, $rootScope.boleto.token, $rootScope.boleto.id).then(_onSend).catch(onErr)

                $rootScope.onRemind = ->
                        _onSend = (result) ->
                                toastr.info("Boleto", "Boleto #{result.payment_id} re-enviado")
                        user = firebase.auth().currentUser
                        boletoService.remind(user.uid, $rootScope.boleto.token, $rootScope.boleto.id).then(_onSend).catch(onErr)
                                
                # Fake listeners para atualizar
                # os formulários typeform
                # em rotas específicas como
                # - /formularios/:uuid/:action
                #if  $location.url().match /^\/boletos\/\w+$/
                #        boletoService.getAll().then (boletos) ->

                # - /boletos/:invoiceid
                if  $location.url().match /^\/boletos\/[a-zA-Z0-9]+$/
                        $rootScope.boleto = null
                        # TODO
                        db.ref("boletos").once 'value', (boletos) ->
                                for b in boletos.val()
                                        for _b in b
                                                console.log _b.invoice
                                                console.log(invoiceid)
                                                if _b.invoice is invoiceid 
                                                        $rootScope.boleto = _b
                                
                #angular.extend this, $controller('AuthCtrl', {$scope:$rootScope})
