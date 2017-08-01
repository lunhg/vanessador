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

                        # BUG angular está chamando duas vezes cada controlador
                        # como medida provisória, checar se o email já foi enviado
                        # para n enviar de novo e causar erro
                        db = firebase.database()
                        db.ref("boletos/#{$rootScope.currentForm}").once 'value', (boletos) ->
                                for b in boletos.val()
                                        if b.token is token and b.invoice is id
                                                if b.status is 'DRAFT'
                                                        boletoService.send(token, id).then(_onSend).catch(onErr)
                        
                $rootScope.onCancel = ->
                        _onSend = (result) -> $location.path('/formularios')
                        db = firebase.database()
                        token = $rootScope.boleto.token
                        id = $rootScope.boleto.invoice
                        db.ref("boletos/#{$rootScope.currentForm}").once 'value', (boletos) ->
                                for b in boletos.val()
                                        if b.token is token and b.invoice is id
                                                boletoService.cancel($rootScope.boleto.token, $rootScope.boleto.invoice).then(_onSend).catch(onErr)

                $rootScope.onRemind = ->
                        _onSend = (result) -> $location.path('/formularios')
                        db = firebase.database()
                        db.ref("boletos/#{$rootScope.currentForm}").once 'value', (boletos) ->
                                for b in boletos.val()
                                        if b.token is $rootScope.token and b.invoice is $rootScope.boleto.invoice
                                                if b.status is 'SENT'
                                                        onSent = -> b.status = 'REMIND'
                                                        boletoService.remind($rootScope.token, $rootScope.boleto.invoice).then(_onSend).then(onSent).catch(onErr)
                        
                if  $location.url().match /^\/boletos\/+$/
                        $rootScope.boletos = null
                        db.ref("boletos/").once 'value', (boletos) ->
                                $rootScope.boletos = boletos.val()
                                console.log $rootScope.boletos
                                
                # - /boletos/:invoiceid
                if  $location.url().match /^\/boletos\/[a-zA-Z0-9]+$/
                        $rootScope.boleto = null
                        # TODO
                        db.ref("boletos/").once 'value', (boletos) ->
                                for b in boletos.val()
                                        for _b in b
                                                console.log _b.invoice
                                                console.log(invoiceid)
                                                if _b.invoice is invoiceid 
                                                        $rootScope.boleto = _b
                                
                #angular.extend this, $controller('AuthCtrl', {$scope:$rootScope})
