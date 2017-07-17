# Controlador de autenticacao
# TODO Separar os controles    
onAuth = ($rootScope, $http, $location) ->

        # checkout $rootScope.popup as red
        onAlertDanger = ->
                document.getElementById('popup').classList.remove("alert-success")
                document.getElementById('popup').classList.add("alert-danger")

        # checkout $rootScope.popup as green
        onAlertSuccess = ->
                document.getElementById('popup').classList.remove("alert-danger")
                document.getElementById('popup').classList.add("alert-success")

        # checkout $rootScope.popup message and type
        onErr  = (err) ->
                $rootScope.popup = "Error #{err.code}: #{err.message}"
                onAlertDanger()
                $location.path( "/" ).replace()

        # checkout $rootScope.popup message success on signout
        onSignout = ->
                $rootScope.popup = "Saiu com sucesso do sistema"
                onAlertSuccess()
                $location.path( "/" ).replace()


        # checkout $rootScope.popup message success on login
        onLogin = (result) ->
                $rootScope.popup = "Login feito com sucesso"
                onAlertSuccess()
                $location.path( "/" ).replace()

        # checkout $rootScope.popup message success on login
        onConfirmEmailVerify = ->
                $rootScope.popup = "Enviamos um email de confirmação para #{firebase.auth().currentUser}"
                onAlertSuccess()
                $location.path( "/" ).replace()

        # checkout $rootScope.popup message success on reset password
        onResetPasswordSendEmail = ->
                $rootScope.popup = "Enviamos um email de confirmação para #{email}"
                onAlertSuccess()
                $location.path( "/" ).replace()
                
        # on Update password
        onUpdatePassword = ->
                $rootScope.popup = "Senha redefinida com sucesso"
                onAlertSuccess()
                $location.path( "/" ).replace()
                
        # on reauthentication, need to be logged or reauthenticated
        onReauthenticate = (user, p1) -> user.updatePassword(p1).then(onUpdatePassword).catch onErr

        # Reset Password
        onResetPassword = (data) ->
                if document.getElementById('reset_login_password').value is document.getElementById('reset_login_password_confirm').value
                        user = firebase.auth().currentUser
                        pwd  = document.getElementById('reset_login_password_confirm').value



        # Funcao auxiliar par $rootScope.confirmResetPassword
        onConfirmResetPassword = (config) ->
                if query.apiKey is config.apiKey
                        firebase.auth().applyActionCode(query.oobCode).then(onResetPasswod)
                else
                        console.log 'apiKey incorrect'

        # Random Password
        randomPassword = (n) ->
                c = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!?_-'.split ''
                (c[Math.floor(Math.random() * c.length)] for i in [0..n-1]).join('')

        # Funcao para enviar email de verificação após criar conta
        onSendEmailVerify =  ->
                if firebase.auth().currentUser isnt null then firebase.auth().currentUser.sendEmailVerification().then(onConfirmEmailVerify).catch(onErr)

        # Esta função checa o domínio do email do usuário.
        # Permitido apenas para @itsrio.org e o desenvolvedor
        onCheckEmailDomain = (email) -> email.match /\w+@itsrio.org/ or email is  "gcravista@gmail.com"

        # Função para retornar erro durante o login
        # ou registro do usuário
        onLoginOrCreateErr = ->
                u = firebase.auth().currentUser
                msg = "Usuário #{u.displayName or u.email} já está logado"
                console.log msg
                onErr(new Error(msg))
                
        # Login Google
        # realizado com o firebase
        $rootScope.loginGoogle = ->
                if not firebase.auth().currentUser
                        provider = new firebase.auth.GoogleAuthProvider()
                        provider.addScope('https://www.googleapis.com/auth/userinfo.profile')
                        firebase.auth().signInWithPopup(provider).then(onLogin).catch(onErr)
                else
                        onLoginOrCreateErr()

        # Login email password
        # realizado com o firebase
        $rootScope.loginEmailAndPassword = ->
                if not firebase.auth().currentUser
                        # check email domain
                        email = document.getElementById('input_login_email').value
                        if onCheckEmailDomain(email)
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
                        if onCheckEmailDomain email
                                pwd = randomPassword(16)
                                cred = firebase.auth().EmailAuthProvider.credential(user, pwd)
                                console.log cred
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
                
        # Para o menu funcionar corretamente com o bootstrap
        # Vamos adicionar as interações
        $rootScope.onDropmenu = (what)->
                if $rootScope[what] is null or $rootScope[what] is undefined
                        $rootScope[what] = false

                
                if not $rootScope[what]                         
                        document.getElementById(what).classList.add('open')
                        document.getElementById(what).setAttribute('aria-expanded', 'true')
                else
                        document.getElementById(what).classList.remove('open')
                        document.getElementById(what).setAttribute('aria-expanded', 'false')
                $rootScope[what] = not $rootScope[what]
                

        # icone de loading
        $rootScope.onLoading = false

        # Dados typeform
        $rootScope.typeformData = null
        $rootScope.searchForm = (id, options)->
                $rootScope.onLoading = true
                query = []
                search = document.getElementById(id)
                t = if search.value isnt '' then search.value else search.getAttribute('placeholder')
                console.log t
                query.push "uuid=#{t}"
                query.push "#{k}=#{v}" for k,v of options
                _url = "/typeform/data-api?#{query.join('&')}"
                console.log _url
                $http({
                        method: 'GET',
                        url: _url
                }).then (response) ->
                        $rootScope.onLoading = false
                        console.log response.data
                        $rootScope.typeformData = response.data

        $rootScope.novo = (ref, obj) ->
                id = randomPassword(6)
                firebase.database().ref("/#{firebase.auth().currentUser}/cursos/#{id}").set(obj)

# Registre o controlador
app.controller "AuthCtrl", ['$rootScope', '$http', '$location', onAuth]
