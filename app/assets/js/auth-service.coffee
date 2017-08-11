# Primeiro inicialize as rotas angular atraves
# de templates. Para recuperar esses templates, precisamos
# antes requerilos do servidor.
fetchAuthService = ->
        # A mensagem de carregamento inicial
        # deve ser atualizada
        loader = document.getElementById('masterLoader')
        p = loader.children[9]
        p.innerHTML = "Construindo serviço de autorização..."
        Service =  ($http, $location, $route, $window, $rootScope, mainService, toastr) ->
                                
                AuthService = {}
                # # Funções auxiliares
                # Estas funções auxiliam as funções principais do $rootScope
                # como chcagem de erro, login, logout, envio de email
                # checkout $rootScope.popup message and type
                AuthService.onErr  = (err) ->
                        toastr.error("Erro #{err.code}", err.message)
                        $location.path('/')
                        
                # checkout $rootScope.popup message success on signout
                AuthService.onSignout = ->
        
                        # Apresente ao usuário uma mensagem de sucesso
                        user = firebase.auth().currentUser
                        if not user
                                toastr.success('Logout', "você saiu do sistema")
                                # Isso é necessário para reatualizar os dados
                                $rootScope.user = null
                                $location.path('/login')
                        else
                                AuthService.onErr new Error("Usuário #{user.uid} ainda está logado")
                                $location.path('/formularios')
                                
                # checkout $rootScope.popup message success on login
                AuthService.onLogin = (result) ->
                        # Apresente ao usuário uma mensagem de sucesso
                        user = firebase.auth().currentUser
                        toastr.success('Bem vindo', "#{user.displayName or user.email}")
                        $location.path('/formularios')
                        $route.reload()
                
                # Funcao para enviar email de verificação após criar conta
                AuthService.onSendEmailVerify =  ->
                        nextRoute = "/login"
                        if firebase.auth().currentUser
                                user = firebase.auth().currentUser
                                
                                # memorize um popup
                                onSend = ->
                                        msg = "Enviamos um email  #{user.displayName or user.email}"
                                        $rootScope.resetPassword = true
                                        $rootScope.verifyEmail = false
                                        toastr.success('Email', msg)
                                        $location.path('/formularios')
                                        $route.reload()
                                user.sendEmailVerification().then(onSend).catch(AuthService.onErr)
                        
        
                # Recupere dados de configuração do servidor
                AuthService.onGetConfig = -> $http(method: 'GET',url: '/config')
                
                # checkout $rootScope.popup message success on login
                AuthService.onConfirmEmailVerify = ->
                        query = $location.search('mode', 'oobCode', 'apiKey')
                        onGetConfig().then( (config) ->
                                onSend = ->
                                        user = firebase.auth().current
                                        toastr.success('Email', "#{user.email} verificado")
                                        $location.path('/formularios')
                                        $route.reload()
                                if query.apiKey is config.apiKey
                                        firebase.auth().applyActionCode(query.oobCode).then(onSend)
                                else
                                        AuthService.onErr new Error 'apiKey incorrect'
                        ).catch(AuthService.onErr)
                        
                # Função que confirma a troca de senha
                AuthService.onConfirmResetPassword = (id_e, id_p)->
                        b = document.getElementById(id_e).value is document.getElementById(id_p).value
                        if b
                                user = firebase.auth().currentUser

                                # Quando a verificação do código de ação for possível
                                # Aplique a atualização da senha 
                                onApply = ->
                                        _onApply = -> toastr.success('Senha', 'Senha trocada com sucesso!')
                                        pwd  = document.getElementById(id_p).value
                                        user.updatePassword(pwd).then(_onApply).catch AuthService.onErr
                                        
                                # Verifique o código oob e depois resete a senha e notifique o usuário
                                firebase.auth().applyActionCode(query.oobCode).then(onApply).catch(AuthService.onErr)
                                
                        else
                                AuthService.onErr new Error 'Senhas não coincidem'

                # ## Login
                # 
                # ### Login Google
                # - realizado com o firebase
                # - Necessita do provedor Google
                # - ASsim que autorizar, o usuário é notificado que logou
                # - Utiliza a função auxiliar `onLogin`
                AuthService.loginGoogle = ->
                        if not firebase.auth().currentUser
                                provider = new firebase.auth.GoogleAuthProvider()
                                provider.addScope('https://www.googleapis.com/auth/userinfo.profile')
                                firebase.auth().signInWithPopup(provider).then(AuthService.onLogin).catch(AuthService.onErr)
                        else
                               AuthService.onErr new Error  "User already logged"


                # ### Login email e senha 
                # - realizado com o firebase
                # - requer email e senha independentes
                # - Os únicos autorizados são aqueles com domínio @itsrio.org e o desenvolvedor 
                # - Assim que autorizar, o usuário é notificado que entrou no sistema
                # - Utiliza a função auxiliar `onLogin`
                AuthService.loginEmailAndPassword = (id_login, id_password, restricted) ->
                        if not firebase.auth().currentUser
                                email = document.getElementById(id_login).value
                                if email.match(restricted)
                                        AuthService.credentials = firebase.auth.EmailAuthProvider.credential(email, document.getElementById(id_password).value)
                                        firebase.auth().signInWithEmailAndPassword(email,(document.getElementById(id_password).value)).then(AuthService.onLogin).catch(onErr)
                                else
                                        onErr(new Error("Conta de email não permitida"))
                        else
                                AuthService.onErr new Error "User already logged"

                # ### Cadastro
                # - realizado com o firebase
                # - requer email e senha independentes
                # - Os únicos autorizados são aqueles com domínio @itsrio.org e o desenvolvedor
                # - Assim que autorizar, o usuário é notificado que foi enviado um email de confirmação e o usuário entra no sistema
                AuthService.createUserWithEmailAndPassword = (id_email, id_password, restricted) ->
                        if not firebase.auth().currentUser
                                # check email domain
                                email = document.getElementById(id_email).value
        
                                # Permitido apenas para @itsrio.org e o desenvolvedor
                                if email.match(restricted)
                                        pwd = document.getElementById(id_password).value
                                        firebase.auth().createUserWithEmailAndPassword(email, pwd).then(AuthService.onSendEmailVerify).catch(onErr)
                                        
                                else
                                       AuthService.onErr(new Error("Conta de email não permitida")) 

                 # ### Resete a senha
                # - realizado com o firebase
                # - enviamos  uma requisição por email para executar posteriormente $rootScope.confirmResetPassword
                AuthService.sendPasswordResetEmail = (id_email)->
                        email = document.getElementById(id_email).value
                        firebase.auth().sendPasswordResetEmail(email).then(->
                                msg = "Enviamos um email para #{email} com um novo token"
                                toastr.info('Recuperação de senha', msg)
                                $location.path('/login')
                                $route.reload()
                        ).catch(onErr)


                AuthService.verifyPhone = (id) ->
                        tel = document.getElementById(id).value
                        PhoneAuthProvider = firebase.auth.PhoneAuthProvider
                        provider = new PhoneAuthProvider()
                        provider.verifyPhoneNumber(tel,mainService.applicationVerifier)
                        
                AuthService.sendSMS = (id, query) ->
                        
                AuthService.confirmSMS = (code) ->
                                
                # Para trocar a senha, é necessário
                # que o usuário esteja logado ou tenha
                # logado recentemente. Supondo que alguém
                # nunca logou, vamos buscar reautenticar o usuário
                # através do login por celular e depois
                # trocamos a senha
                AuthService.confirm = (id_a, id_b, query) ->
                        _confirmationResult = null
                        b1 = document.getElementById(id_a).value
                        b2 = document.getElementById(id_b).value
                        if b1 is b2                
                                AuthService.onGetConfig().then (config) ->
                                        if query.apiKey is config.data.apiKey
                                                if query.mode is 'resetPassword'
                                                        # Checar se os emails estão iguais
                                                        AuthService.onConfirmResetPassword(id_a, id_b)
                                                if query.mode is 'confirmEmail'
                                                        m = "Função não implementada ainda"
                                                        onErr new Error m
                                                else
                                                        AuthService.onErr new Error "Chave incorreta"
                        

                        
                        


                # callback para o logout
                AuthService.logout = ->
                        # É necessário limpar parte da base de dados que
                        # memorizavam qual é o formulário atual de cada usuário
                        user = firebase.auth().currentUser
                        _onSignout = -> firebase.auth().signOut().then(AuthService.onSignout).catch(AuthService.onErr)
                        firebase.database().ref("users/#{user.uid}/currentForm").remove().then(_onSignout).catch(AuthService.onErr)

                # Esta função vincula a autenticação por email e senha com a autenticação por oauth
                # https://firebase.google.com/docs/auth/web/account-linking
                AuthService.linkAccount = ->
                        if firebase.auth().currentUser
                                provider = new firebase.auth.GoogleAuthProvider()
                                onLinkProvider = (result) ->
                                        credential = result.credential;
                                        user = result.user
                                        user.reauthenticate(credential)
                                                .then ->
                                                        toastr.info "Login", "usuário reautenticado"
                                                        $rootScope.user = user
                                                .catch(AuthService.onErr)
                                firebase.auth().currentUser.linkWithPopup(provider).then(onLinkProvider).catch(AuthService.onErr)

                        
                return AuthService
        ['$http', '$location', '$route', '$window', '$rootScope', 'mainService', 'toastr', Service]
