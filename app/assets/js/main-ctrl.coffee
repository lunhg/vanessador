fetchMainCtrl = ->
        # A mensagem de carregamento inicial
        # deve ser atualizada
        loader = document.getElementById('masterLoader')
        p = loader.children[9]
        p.innerHTML = "Trabalhando no controlador principal"
        MainCtrl = ($rootScope, $http, $location, $route, $window, authService, formularioService, boletoService, mainService, toastr)->

               
                        
                $rootScope.onAccountDadosPessoais = ->
                        $rootScope.dadosPessoais = true
                        $rootScope.configuracoes = false
                        $rootScope.vinculaConta = false
                        classList = document.getElementById('dadosPessoais').classList
                        classList2 = document.getElementById('configuracoes').classList
                        classList.add('active')
                        classList.add('in')
                        classList2.remove('active')
                        classList2.remove('in')
                        
                $rootScope.onAccountConfiguracoes = ->
                        $rootScope.configuracoes = true
                        $rootScope.dadosPessoais = false
                        $rootScope.vinculaConta = false
                        classList = document.getElementById('configuracoes').classList
                        classList2 = document.getElementById('dadosPessoais').classList
                        classList.add('active')
                        classList.add('in')
                        classList2.add('active')
                        classList2.add('in')

                
                        
                # # Métodos de autenticação
                # ## Login
                # ### login com um popup do google
                # - Dependencias:
                #   - authService
                $rootScope.loginGoogle = ->
                        authService.loginGoogle()

                # ### login com email e senha com regra de acesso
                # - Dependencias:
                #   - authService
                # - A mesma regra deve ser aplicada à base de dados
                $rootScope.loginEmailAndPassword = ->
                        authService.loginEmailAndPassword('input_login_email',
                                'input_login_password',
                                /\w+@itsrio.org|gcravista@gmail.com/)                            


                $rootScope.logout = -> authService.logout()
                        
                # ## Signin
                # ### Criar usuário com email e senha com um popup do google
                # - Dependencias:
                #   - authService
                # - A mesma regra deve ser aplicada à base de dados
                $rootScope.createUserWithEmailAndPassword = ->
                       authService.createUserWithEmailAndPassword('input_signup_email',
                               'input_signup_senha',
                                /\w+@itsrio.org|gcravista@gmail.com/)

                # ## Senhas
                # ### Solicita uma requisição de envio de troca de senha
                # - Dependencias:
                #   - authService
                $rootScope.sendPasswordResetEmail = ->
                        authService.sendPasswordResetEmail('reset_login_email')

                # ### Confirma a requisição de envio de troca de senha
                # - Dependencias:
                #   - authService
                $rootScope.confirm = -> if $location.url().match /\/confirm\?mode\=[a-zA-Z0-9]+\&oobCode\=[a-zA-Z0-9\_\-]+\&apiKey\=[a-zA-Z0-9]+/ then authService.confirm('reset_login_password', 'reset_login_password_confirm', $location.search())

                
                # ### Adiciona número de telefone
                $rootScope.addPhoneNumber = (id)->
                        onVerify = (verificationId) ->
                                $rootScope.whoisPhoneNumber = false
                                $rootScope.confirmationCode = true
                                $rootScope.verificationId = verificationId
                                console.log verificationId
                                toastr.success("Telefone adicionado")
                        mainService.applicationVerifier.verify()
                                .then authService.verifyPhone(id)
                                .then(onVerify)
                                .catch(onErr)

                $rootScope.confirmSMSCode = (id) ->
                        user = firebase.auth().currentUser
                        code = document.getElementById(id).value
                        tel = PhoneAuthProvider.credential($rootScope.verificationId,code)
                        onAddPhoneNumber = -> toastr.info "Telefone", "Número atualizado"
                        user.updatePhoneNumber(tel).then(onAddPhoneNumber).catch(onErr) 
                                
                # ### Envia um SMS para iniciar o processo de troca de senha
                # - Dependencias:
                #   - authService
                $rootScope.sendSMS = -> if $location.url().match /\/confirm\?mode\=[a-zA-Z0-9]+\&oobCode\=[a-zA-Z0-9\_\-]+\&apiKey\=[a-zA-Z0-9]+/ then authService.sendSMS('reset_login_tel', $location.search())
                        
                # ## Contas
                # ### Solicita a vinculação de uma conta google a uma conta email+senha
                # - Dependencias:
                #   - authService
                $rootScope.linkAccount = -> authService.linkAccount()
                

                # # Interações gráficas
                # ## Menu
                # ### Ao passar o mouse (onhover), qq menu deve expandir
                $rootScope.onDropdownmenu = (what, event)->
                        event.preventDefault()                     
                        document.getElementById(what).classList.add('open')
                        document.getElementById(what).setAttribute('aria-expanded', 'true')

                # ### Ao tirar o mouse (onhover), menu deve retrair
                $rootScope.onDropupmenu = (what, event)->
                        event.preventDefault()
                        document.getElementById(what).classList.remove('open')
                        document.getElementById(what).setAttribute('aria-expanded', 'false')
                                
                                
                # Esta função auxilia verificar erros de qq natureza
                onErr  = (err) ->
                        toastr.error(err.code, err.message)
                        console.error(err.code, err.message)
                        
                # # Formulários
                # ## /formularios/novo
                # ### Recuperar um formulario typeform
                # #### e insere no firebase
                # - Dependencias:
                #   - formularioService
                $rootScope.onNovoFormulario = (id, groups...) ->
                        _onNovo = ->
                                $location.path('/formularios')
                                $window.reload()
                        formularioService.novo(id, groups).then(_onNovo).catch(onErr)

                # ## Recupera novamente um formulário
                # ### Recuperar um formulario typeform
                # #### e atualiza no firebase
                # - Dependencias:
                #   - formularioService
                $rootScope.onUpdateFormulario =  (uuid) ->
                        _onUpdate = ->
                                $location.path('/formularios')
                        formularioService.update(uuid).then(_onUpdate).catch(onErr)

                # ## /formularios/:uuid/delete
                # ### Deleta, do firebase, um formulario typeform
                # - Dependencias:
                #   - formularioService
                $rootScope.onDeleteFormulario = (uuid)->
                        _onDel = ->
                                $location.path('/formularios')
                        _uuid = document.getElementById('input_typeform_uuid').value
                        if uuid is _uuid 
                                formularioService.delete(uuid, _uuid).then(_onDel).catch(onErr)
                        else
                                onErr new Error("Formulario Error", "Invalid uuid")
                        

                # ## /formularios/:uuid/respnse/:token
                # ### Cria um boleto
                # #### a partir de uma resposta específica
                # ##### de um formulário específico
                
                                
                $rootScope.onNovoBoleto = ->
                        questions = document.getElementsByClassName('typeform-question')
                        answers = document.getElementsByClassName('typeform-answer')
                        data =
                                phone_country_code: "55"
                                state:"RJ"
                                country_code: "BR"
                                value:'10.00' 

                        for i,q of questions
                                for j,a of answers
                                        if i is j
                                                v = a.innerHTML
                                                switch(q.innerHTML)
                                                        when 'Email' then data['billing_info_email'] = v
                                                        when 'Nome' then data['first_name'] = v
                                                        when 'Sobrenome' then data['second_name'] = v
                                                        when 'Cidade' then data['city'] = v
                                                        when 'Telefone' then data['phone_national_number']=v
                                                
                                        
                         
                        onBoleto = -> $location.path("/formularios")
                        boletoService.novo($rootScope.currentForm, $rootScope.token, data).then(onBoleto).catch(onErr)

        
                # ## /boletos/:invoice
                # ### Envia por email um boleto (DRAFT)
                # A partir de uma resposta específica de um formulário específico
                $rootScope.onSendBoleto = ->
                        user = firebase.auth().currentUser
                        token = $rootScope.boleto.token
                        id = $rootScope.boleto.invoice
                        _onSend = (result)-> toastr.info("Boleto", "Boleto #{id} enviado")
                        
                        # BUG angular está chamando duas vezes cada controlador
                        # como medida provisória, checar se o email já foi enviado
                        # para n enviar de novo e causar erro
                        db = firebase.database()
                        db.ref("boletos/#{$rootScope.currentForm}").once 'value', (boletos) ->
                                for b in boletos.val()
                                        if b.token is token and b.invoice is id
                                                if b.status is 'DRAFT'
                                                        boletoService.send(token, id).then(_onSend).catch(onErr)

        
                # ### Cancela um boleto
                # Será usado apenas quando o boleto for enviado (SENT)
                $rootScope.onCancelBoleto = ->
                        _onSend = (result) -> $location.path('/formularios')
                        db = firebase.database()
                        token = $rootScope.boleto.token
                        id = $rootScope.boleto.invoice
                        db.ref("boletos/#{$rootScope.currentForm}").once 'value', (boletos) ->
                                for b in boletos.val()
                                        if b.token is token and b.invoice is id
                                                boletoService.cancel($rootScope.boleto.token, $rootScope.boleto.invoice).then(_onSend).catch(onErr)

        
                # ### Cria um boleto
                # Relembra o email ao usuário caso seja notado
                # uma demora
                $rootScope.onRemindBoleto = ->
                        _onSend = (result) ->
                                $location.path('/formularios')
                        boletoService.remind($rootScope.token, $rootScope.boleto.invoice)
                                .then(_onSend)
                                .catch(onErr)
                

                $rootScope.onDeleteBoleto = ->
                        form = $rootScope.currentForm
                        id = $rootScope.boleto.invoice
                        _onDelete = ->
                                toastr.success("Formulário #{form}", "Boleto #{id} deletado")
                                $rootScope.boleto = null
                                $location.path('/formularios')
                        
                        boletoService.delete(form, id).then(_onDelete)

                
                



                # ## Configuração de aplicativo
                # GET /config
                $http.get('/config').then (config) ->
                        if not firebase.apps.length
                                firebase.initializeApp config.data

                        # # Reconhecimento
                        # Somente após reconhecer o login,
                        # o usuário é carregado e a página muda
                        # alguns elementos

                        firebase.auth().onAuthStateChanged (user) ->
                                if user then $rootScope.user = user

                phase = $rootScope.$$phase
                apply = @$apply
                        
                $rootScope.$watch 'user', (newUser, oldUser) ->
                        #if phase is '$apply' or phase is '$digest'
                        #        fn()
                        #else
                        #        apply(fn)
                        #
                        
                        mainService._on(/^\/confirm\?.*$/)
                                .then mainService.onConfirm
                                
                        mainService._on(/^\/formularios$/)
                                .then mainService.onFormularios
                                .then (formularios) ->
                                        $rootScope.registeredForms = formularios

                        mainService._on(/^\/formularios\/\w+\/\w+$/)
                                .then mainService.onFormulariosAction
                                .then (result) ->
                                        $rootScope[result.action] = result.val
                                        
                        mainService._on(/^\/formularios\/\w+\/\w+\/[a-zA-Z0-9]+$/)
                                .then mainService.onFormulariosActionToken
                                .then (result) ->
                                        for k,v of result
                                                $rootScope[k] = v

                        mainService._on(/^\/boletos$/)
                                .then mainService.onBoletos
                                .then (boletos) ->
                                        $rootScope.boletos = boletos
                                        
                        mainService._on(/^\/boletos\/[a-zA-Z0-9]+$/)
                                .then mainService.onBoletosInvoice
                                .then (boleto) ->
                                        $rootScope.boleto = boleto

                        mainService._on(/^\/conta\/telefone\/vincular/)
                                .then mainService.onVincularPhone
                                .then (result) ->
                                        console.log result
                                        
                                        

                
