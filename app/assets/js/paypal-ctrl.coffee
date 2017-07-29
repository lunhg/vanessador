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

                # - /boletos/:invoiceid
                if  $location.url().match /^\/boletos\/[a-zA-Z0-9]+$/
                        $rootScope.onLoading = true
                        $rootScope.currentBoleto = $location.url().split('/boletos/')[1].split('/')[0]
                        invoiceid = $location.url().split('/boletos/')[1].split('/')[1]
                        user = firebase.auth().currentUser.uid
                        db = firebase.database()

                        # TODO
                        db.ref("boletos").once 'value', (boletos) ->
                                for b in boletos.val()
                                        for _b in b
                                                console.log _b.invoice
                                                console.log(invoiceid)
                                                if _b.invoice is invoiceid 
                                                        $rootScope.boleto = _b
                                
                #angular.extend this, $controller('AuthCtrl', {$scope:$rootScope})
