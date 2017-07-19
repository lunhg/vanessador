# Controlador de autenticacao
# TODO Separar os controles    
onAuth = ($rootScope, $http, $location, $window, $route) ->
        # modalDialog apresenta
        # popups que retornam
        # mensagens de erro ou
        # mensagens úteis de notificação
        # como sucesso no login, logout
        # troca de senha
        $rootScope.modalShown = false
        $rootScope.modalContent = null
        $rootScope.toggleModal = (content)->
                unless $rootScope.modalShown then $rootScope.modalContent = content
                $rootScope.modalShown = not $rootScope.modalShown
                
        onReload = ->
                $location.path($rootScope.nextRoute)
                $route.reload()
                
        # checkout $rootScope.popup message and type
        onErr  = (err) ->
                console.log err
                $rootScope.nextRoute = '/'
                $rootScope.toggleModal("<p>#{err.code}:</p><br/><br/><p>#{err.message}</p>")
                onReload()
        # checkout $rootScope.popup message success on signout
        onSignout = ->
                $rootScope.nextRoute = '/login'
                $rootScope.toggleModal("<p>Saiu do vanessador com sucesso</p>")
                onReload()

        # checkout $rootScope.popup message success on login
        onLogin = (result) ->
                $rootScope.nextRoute = '/formularios'
                user = firebase.auth().currentUser
                $rootScope.toggleModal("<p>Bem vindo #{user.displayName or user.email}</p>")
                onReload()
                $window.location.reload()

        # Funcao para enviar email de verificação após criar conta
        onSendEmailVerify =  ->
                $rootScope.nextRoute = "/login"
                onSend = -> $rootScope.toggleModal("<p>Enviamos um email  #{user.displayName or user.email}</p>")
                if firebase.auth().currentUser then firebase.auth().currentUser.sendEmailVerification().then(onSend).then(onReload).catch(onErr)
                        
        # checkout $rootScope.popup message success on login
        onConfirmEmailVerify = ->
                query = $location.search('mode', 'oobCode', 'apiKey')
                $http(method: 'GET',url: '/config').then(->
                        onSend = -> $rootScope.toggleModal("<p>#{user.email} verificado</p>")
                        $rootScope.nextRoute = '/'
                        if query.apiKey is config.apiKey
                                firebase.auth().applyActionCode(query.oobCode).then(onSend).then(onReload)
                        else
                                onErr new Error 'apiKey incorrect'
                ).catch(onErr)

        # Funcao auxiliar par $rootScope.confirmResetPassword
        onConfirmResetPassword = (config) ->
                if query.apiKey is config.apiKey
                        user = firebase.auth().currentUser
                        pwd  = document.getElementById('reset_login_password_confirm').value
                        _onApply = -> $rootScope.toggleModal("<p>Senha atualizada com sucesso #{user.email} </p>")
                        onApply = -> user.updatePassword(pwd).then(_onApply).catch onErr
                                

                        # Checar se os emails estão iguais
                        if document.getElementById('reset_login_password').value is document.getElementById('reset_login_password_confirm').value

                                # Verifique o código oob e depois resete a senha e notifique o usuário
                                firebase.auth().applyActionCode(query.oobCode).then(onApply).catch(onErr)
                        else
                                onErr new Error 'Senhas não coincidem'

        # Random Password
        randomPassword = (n) ->
                c = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!?_-'.split ''
                (c[Math.floor(Math.random() * c.length)] for i in [0..n-1]).join('')


        # Login Google
        # realizado com o firebase
        $rootScope.loginGoogle = ->
                if not firebase.auth().currentUser
                        provider = new firebase.auth.GoogleAuthProvider()
                        provider.addScope('https://www.googleapis.com/auth/userinfo.profile')
                        firebase.auth().signInWithPopup(provider).then(onLogin).catch(onErr)
                else
                       onErr new Error 

        # Login email password
        # realizado com o firebase
        $rootScope.loginEmailAndPassword = ->
                if not firebase.auth().currentUser
                        # check email domain
                        email = document.getElementById('input_login_email').value
                        # Permitido apenas para @itsrio.org e o desenvolvedor
                        console.log email
                        console.log email.match /\w+@itsrio.org/
                        console.log email.match /gcravista@gmail.com/
                        if email.match(/\w+@itsrio.org/) or email.match(/gcravista@gmail.com/)
                                firebase.auth().signInWithEmailAndPassword(email,(document.getElementById('input_login_password').value)).then(onLogin).catch(onErr)
                        else
                                onErr(new Error("Conta de email não permitida"))
                else
                        onLoginOrCreateErr()                                

        
        # Signup
        # Cheque o domínio do email (@itsrio.org)
        # Crie o usuário se for permitido
        # Envie um email resetando a senha
        $rootScope.createUserWithEmailAndPassword = ->
                if not firebase.auth().currentUser
                        # check email domain
                        email = document.getElementById('input_signup_email').value

                        # Permitido apenas para @itsrio.org e o desenvolvedor
                        if email.match(/\w+@itsrio.org/) or email.match(/gcravista@gmail.com/)
                                pwd = document.getElementById('input_signup_senha').value
                                
                                firebase.auth().createUserWithEmailAndPassword(email, pwd).then(onSendEmailVerify).catch(onErr)
                                
                        else
                               onErr(new Error("Conta de email não permitida")) 
                else
                        onLoginOrCreateErr()

        # Resete a senha
        # Antes de tudo enviamos
        # uma requisição por email
        # para executar $rootScope.confirmResetPassword
        $rootScope.sendPasswordResetEmail = ->
                email = document.getElementById('reset_login_email').value
                firebase.auth().sendPasswordResetEmail(email).then(onResetPasswordSendEmail).catch(onErr)

        # Quando receber um email de resetar a senha e clicar ou copiar e colar
        # o endereço de confirmação, o cliente recebe um oobCode que deve ser
        # acompanhado da chave api do aplicatvo
        $rootScope.confirmResetPassword = ->
                query = $location.search('mode', 'oobCode', 'apiKey')
                $http(method: 'GET',url: '/config').then(onConfirmResetPassword).catch(onErr)
        
        # callback para o logout
        $rootScope.logout = -> firebase.auth().signOut().then(onSignout).catch(onErr)

        # Esta função vincula a autenticação por email e senha com a autenticação por oauth
        # https://firebase.google.com/docs/auth/web/account-linking
        $rootScope.linkAccount = ->
                if firebase.auth().currentUser
                        provider = new firebase.auth.GoogleAuthProvider()
                        onLinkProvider = (result) ->
                                credential = result.credential;
                                user = result.user;
                        firebase.auth().currentUser.linkWithPopup(provider).then(onLinkProvider).catch(onErr)
                
        # Para o menu funcionar corretamente com o bootstrap
        # Vamos adicionar as interações
        $rootScope.onDropdownmenu = (what)->                     
                document.getElementById(what).classList.add('open')
                document.getElementById(what).setAttribute('aria-expanded', 'true')

        $rootScope.onDropupmenu = (what)->
                document.getElementById(what).classList.remove('open')
                document.getElementById(what).setAttribute('aria-expanded', 'false')


        # Dados typeform
        $rootScope.typeformData = null
                
        $rootScope.$on '$routeChangeSuccess', (event, next, current) ->
                event.preventDefault();
                console.log $location.url()                             
                
        $rootScope.onNovo = (ref, id_group, groups...) ->
                o = {}
                try
                        for e in groups
                                if e isnt 'tags'
                                        v = document.getElementById("input_typeform_#{e}").value
                                        o[e] = v
                                else
                                        _v = document.getElementById("input_typeform_#{e}").value
                                        v = _v.split(" ")
                                        o[e] = v
                        user = firebase.auth().currentUser
                        o.owner = user.uid
                        firebase.database().ref("#{ref}/").set(obj).catch(onErr)
                        onReload()
                catch e
                        onErr e

        $rootScope.dadosPessoais = true
        $rootScope.configuracoes = false
        $rootScope.onAccountDadosPessoais = ->
                $rootScope.configuracoes = false
                $rootScope.dadosPessoais = true
        $rootScope.onAccountConfiguracoes = ->
                $rootScope.configuracoes = true
                $rootScope.dadosPessoais = false
                
        # Fake listeners para atualizar
        # os formulários typeform
        # em rotas específicas como
        __onLoadForm__ = (url) ->
                $rootScope.onLoading = true
                query = [url+"?"]
                uuid = $location.url().split('/formularios/')[1].split('/')[0]
                query.push "uuid=#{uuid}"
                query.push "#{k}=#{v}" for k,v of {completed:true, limit:10}
                query.join('&')

        # - /formularios
        if $location.url().match /^\/formularios$/
                # atualize a base de dados
                firebase.database().ref('formularios/').once 'value', (snapshot) ->
                        $rootScope.registeredForms = snapshot.val()
                        
        # - /formularios/:uuid/:action
        if  $location.url().match /^\/formularios\/\w+\/\w+$/
                _url = __onLoadForm__("/typeform/data-api")
                console.log _url
                $rootScope.onLoading = true
                $rootScope.currentForm  = $location.url().split('/formularios/')[1].split('/')[0]
                firebase.database().ref('formularios/').once 'value', (snapshot) ->
                        values = snapshot.val()
                        for val in values
                                if val.uuid is $rootScope.currentForm
                                        $rootScope.currentFormUrl = "https://#{val.base_url}/#{val.uuid}"

                                        
                        $http({
                                method: 'GET',
                                url: _url
                        }).then (response) ->
                                $rootScope.typeformData = response.data
                                user = firebase.auth().currentUser.uid
                                firebase.database().ref("users/#{user}/currentForm").set(response.data).then(-> $rootScope.onLoading = false)
                                
        # - /formularios/:uuid/:action/:token
        if  $location.url().match /^\/formularios\/\w+\/\w+\/[a-zA-Z0-9]+$/
                user = firebase.auth().currentUser.uid
                firebase.database().ref("users/#{user}/currentForm").once 'value', (snapshot) ->
                        $rootScope.currentToken = $location.url().split('/formularios/')[1].split('/')[2]
                        console.log $rootScope.currentToken
                        for e in snapshot.val().responses
                                if e.token is $rootScope.currentToken
                                        $rootScope.answers = e.answers
                                        
                        $rootScope.questions = snapshot.val().questions 
                        console.log $rootScope[e] for e in 'answers questions'.split(' ')
                        $rootScope.onLoading = false
                        
# Registre o controlador
app.controller "AuthCtrl", ['$rootScope', '$http', '$location', '$window', '$route', onAuth]
