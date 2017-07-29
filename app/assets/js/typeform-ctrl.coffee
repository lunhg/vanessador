fetchTypeform = ->
        # A mensagem de carregamento inicial
        # deve ser atualizada
        loader = document.getElementById('masterLoader')
        p = loader.children[9]
        p.innerHTML = "Trabalhando no typeform..."
        TypeformCtrl = ($rootScope, $http, $location, $window, $controller, toastr, formularioService, boletoService)->

                # # Funções auxiliares
                # Estas funções auxiliam as funções principais do $rootScope
                # como chcagem de erro, login, logout, envio de email
                # checkout $rootScope.popup message and type
                onErr  = (err) ->
                        toastr.error(err.code, err.message)
                        
                        # Isso é necessário para reatualizar os dados
                        $window.location.reload()
                        
                # Dados typeform
                $rootScope.typeformData = null                          

                $rootScope.onNovo = (id, groups...) ->
                        _onNovo = ->
                                $location.path('/formularios')
                                $window.reload()
                        formularioService.novo(id, groups).then(_onNovo).catch(onErr)

                $rootScope.onUpdate =  (uuid) ->
                        _onUpdate = ->
                                $location.path('/formularios')
                        formularioService.update(uuid).then(_onUpdate).catch(onErr)

                $rootScope.onDelete = (uuid)->
                        _onDel = ->
                                $location.path('/formularios')
                        _uuid = document.getElementById('input_typeform_uuid').value
                        if uuid is _uuid 
                                formularioService.delete(uuid, _uuid).then(_onDel).catch(onErr)
                        else
                                onErr new Error("Formulario Error", "Invalid uuid")

                $rootScope.onNovoBoleto = ->
                        answers = document.getElementsByClassName('typeform-answer')
                        data =
                                first_name: answers.item(0).innerHTML
                                second_name: answers.item(1).innerHTML
                                city: answers.item(3).innerHTML
                                billing_info_email:answers.item(4).innerHTML
                                phone_country_code: "55"
                                phone_national_number: answers.item(5).innerHTML
                                state:"RJ"
                                country_code: "BR"
                                value:'10.00'
                        $rootScope.boleto = null  
                        onBoleto = ->
                                $location.path("/formularios/#{$rootScope.currentForm}/responses/#{$rootScope.token}")
                                $window.reload()
                        boletoService.novo($rootScope.currentForm, $rootScope.token, data).then(onBoleto).catch(onErr)
        
                # - /formularios
                if $location.url().match /^\/formularios$/
                        # atualize a base de dados
                        $rootScope.onLoading = true
                        firebase.database().ref('formularios/').once 'value', (snapshot) ->
                                $rootScope.typeforms = snapshot.val()
                                $rootScope.onLoading = false
                                
                # - /formularios/:uuid/:action
                if  $location.url().match /^\/formularios\/\w+\/\w+$/
                        $rootScope.onLoading = true
                        $rootScope.currentForm = $location.url().split('/formularios/')[1].split('/')[0]
                        action = $location.url().split('/formularios/')[1].split('/')[1]
                        user = firebase.auth().currentUser.uid
                        firebase.database().ref("#{action}/#{$rootScope.currentForm}").once 'value', (snapshot) ->
                                $rootScope.onLoading = false
                                $rootScope[action] = snapshot.val()
                                
                                                
                # - /formularios/:uuid/:action/:token
                if  $location.url().match /^\/formularios\/\w+\/\w+\/[a-zA-Z0-9]+$/
                        $rootScope.onLoading = true
                        $rootScope.boletos = []
                        $rootScope.currentForm = $location.url().split('/formularios/')[1].split('/')[0]
                        action = $location.url().split('/formularios/')[1].split('/')[1]
                        token = $location.url().split('/formularios/')[1].split('/')[2]
                        user = firebase.auth().currentUser.uid
                        db = firebase.database()
                        db.ref("boletos/#{$rootScope.currentForm}").once 'value', (boletos) ->
                                if boletos.val() isnt null
                                        for b in boletos.val()
                                                console. log b
                                                if b.token is token
                                                        $rootScope.boleto = b
                        onAction = (r) ->
                                if action is 'responses'
                                        answers = []
                                        db.ref("questions/#{$rootScope.currentForm}").once 'value', (a) ->
                                                for _a in a.val()
                                                        for _r in r.val()
                                                                for k,v of _r.answers
                                                                        if _a.id is k and _r.token is token
                                                                                o = {}
                                                                                o.question = _a.question
                                                                                o.response = v
                                                                                answers.push o
                                                                                $rootScope.token = token
                                        $rootScope.answers = answers
                        db.ref("#{action}/#{$rootScope.currentForm}").once 'value', onAction
                       
                                        

                        
                #angular.extend this, $controller('AuthCtrl', {$scope:$rootScope})
