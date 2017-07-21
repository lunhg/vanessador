# Controlador de autenticacao
# TODO Separar os controles    
fetchAuthCtrl = ->
        console.log "Trabalhando na autorização..."
        AuthCtrl = ($rootScope, $http, $location, $window, $route, dialogService) ->

                # # Apresentação de dados
                # - /contas
                $rootScope.dadosPessoais = true
                $rootScope.configuracoes = false
                $rootScope.onAccountDadosPessoais = ->
                        $rootScope.configuracoes = false
                        $rootScope.dadosPessoais = true
                $rootScope.onAccountConfiguracoes = ->
                        $rootScope.configuracoes = true
                        $rootScope.dadosPessoais = false
                
                # # Funções auxiliares
                # Estas funções auxiliam as funções principais do $rootScope
                # como chcagem de erro, login, logout, envio de email
                # checkout $rootScope.popup message and type
                onErr  = (err) ->
                        console.log err
                        $rootScope.nextRoute = '/'
                        user = firebase.auth().currentUser.uid
        
                        # Apresente ao usuário o erro
                        user = firebase.auth().currentUser
                        d = dialogService()
                        d.save('danger', "#{err.code}: #{err.message}")
                        d.show()
                        # Isso é necessário para reatualizar os dados
                        $location.path('/')
        
                # checkout $rootScope.popup message success on signout
                onSignout = ->
                        nextRoute = '/login'
        
                        # Apresente ao usuário uma mensagem de sucesso
                        user = firebase.auth().currentUser
                        d = dialogService()
                        d.save('success', "Saiu do vanessador com sucesso")
                        d.show()
                        # Isso é necessário para reatualizar os dados
                        $location.path(nextRoute)
        
                # checkout $rootScope.popup message success on login
                onLogin = (result) ->
                        nextRoute = '/formularios'
        
                        # Apresente ao usuário uma mensagem de sucesso
                        user = firebase.auth().currentUser
                        d = dialogService()
                        d.save('success', "Bem vindo #{user.displayName or user.email}")
                        d.show()
                        # Isso é necessário para reatualizar os dados
                        $location.path(nextRoute)
        
                
                # Funcao para enviar email de verificação após criar conta
                onSendEmailVerify =  ->
                        nextRoute = "/login"
                        if firebase.auth().currentUser
                                user = firebase.auth().currentUser
        
                                # memorize um popup
                                msg = "Enviamos um email  #{user.displayName or user.email}"
                                d = dialogService()
                                d.save('success', "Bem vindo #{user.displayName or user.email}")
                                d.show()
                                user.sendEmailVerification().then(-> $window.location.reload() ).catch(onErr)
                        
        
                # Recupere dados de configuração do servidor
                onGetConfig = (callback) -> $http(method: 'GET',url: '/config').then(callback).catch(onErr)
                
                # checkout $rootScope.popup message success on login
                onConfirmEmailVerify = ->
                        query = $location.search('mode', 'oobCode', 'apiKey')
                        onGetConfig (config) ->
                                user = firebase.auth().current
                                onSend = ->
                                        d = dialogService()
                                        d.save("#{user.email} verificado")
                                        d.show()
                                if query.apiKey is config.apiKey
                                        firebase.auth().applyActionCode(query.oobCode).then(onSend).catch(onErr)
                                else
                                        onErr new Error 'apiKey incorrect'

                # # Funções princiapis de login
                #
                # ## Login
                # 
                # ### Login Google
                # - realizado com o firebase
                # - Necessita do provedor Google
                # - ASsim que autorizar, o usuário é notificado que logou
                # - Utiliza a função auxiliar `onLogin`
                $rootScope.loginGoogle = ->
                        if not firebase.auth().currentUser
                                provider = new firebase.auth.GoogleAuthProvider()
                                provider.addScope('https://www.googleapis.com/auth/userinfo.profile')
                                firebase.auth().signInWithPopup(provider).then(onLogin).catch(onErr)
                        else
                               onErr new Error  "User already logged"
                
                # ### Login email e senha 
                # - realizado com o firebase
                # - requer email e senha independentes
                # - Os únicos autorizados são aqueles com domínio @itsrio.org e o desenvolvedor 
                # - Assim que autorizar, o usuário é notificado que entrou no sistema
                # - Utiliza a função auxiliar `onLogin`
                $rootScope.loginEmailAndPassword = ->
                        if not firebase.auth().currentUser
                                email = document.getElementById('input_login_email').value
                                if email.match(/\w+@itsrio.org/) or email.match(/gcravista@gmail.com/)
                                        firebase.auth().signInWithEmailAndPassword(email,(document.getElementById('input_login_password').value)).then(onLogin).catch(onErr)
                                else
                                        onErr(new Error("Conta de email não permitida"))
                        else
                                onErr new Error "User already logged"                                

                
                # ### Cadastro
                # - realizado com o firebase
                # - requer email e senha independentes
                # - Os únicos autorizados são aqueles com domínio @itsrio.org e o desenvolvedor
                # - Assim que autorizar, o usuário é notificado que foi enviado um email de confirmação e o usuário entra no sistema
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
        
                # ### Resete a senha
                # - realizado com o firebase
                # - enviamos  uma requisição por email para executar posteriormente $rootScope.confirmResetPassword
                $rootScope.sendPasswordResetEmail = ->
                        email = document.getElementById('reset_login_email').value
                        firebase.auth().sendPasswordResetEmail(email).then(onResetPasswordSendEmail).catch(onErr)
        
                # Quando receber um email de resetar a senha e clicar ou copiar e colar
                # o endereço de confirmação, o cliente recebe um oobCode que deve ser
                # acompanhado da chave api do aplicatvo
                $rootScope.confirmResetPassword = ->
                        onGetConfig (config) ->
                                query = $location.search('mode', 'oobCode', 'apiKey')
                                if query.apiKey is config.apiKey
                                
                                        # Checar se os emails estão iguais
                                        b = document.getElementById('reset_login_password').value is document.getElementById('reset_login_password_confirm').value

                                        if b
                                                user = firebase.auth().currentUser

                                                # Quando a verificação do código de ação for possível
                                                # Aplique a atualização da senha 
                                                onApply = ->
                                                        _onApply = ->
                                                                d.save('success', "Senha atualizada com sucesso")
                                                                d.show()
                                                                
                                                        pwd  = document.getElementById('reset_login_password_confirm').value
                                                        user.updatePassword(pwd).then(_onApply).catch onErr
                                        
                                                # Verifique o código oob e depois resete a senha e notifique o usuário
                                                firebase.auth().applyActionCode(query.oobCode).then(onApply).catch(onErr)
                                        else
                                                onErr new Error 'Senhas não coincidem'
        
                # callback para o logout
                $rootScope.logout = ->
                        # É necessário limpar parte da base de dados que
                        # memorizavam qual é o formulário atual de cada usuário
                        user = firebase.auth().currentUser
                        d = dialogService()
                        d.delete()
                        firebase.database().ref("users/#{user.uid}/currentForm").remove().then( ->
                                firebase.auth().signOut().then(onSignout).catch(onErr)
                        ).catch(onErr)
                

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
