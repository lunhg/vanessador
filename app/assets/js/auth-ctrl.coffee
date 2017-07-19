# Controlador de autenticacao
# TODO Separar os controles    
onAuth = ($rootScope, $http, $location, $window, $route) ->
        onReload = ->
                $location.path($rootScope.nextRoute)
                $route.reload()
                
        # checkout $rootScope.popup message and type
        onErr  = (err) ->
                $rootScope.nextRoute = '/'
                onReload()
        # checkout $rootScope.popup message success on signout
        onSignout = ->
                $rootScope.nextRoute = '/login'
                onReload()

        # checkout $rootScope.popup message success on login
        onLogin = (result) ->
                $rootScope.nextRoute = '/formularios'
                user = firebase.auth().currentUser
                onReload()
                $window.location.reload()

        # Funcao para enviar email de verificação após criar conta
        onSendEmailVerify =  ->
                $rootScope.nextRoute = "/login"
                if not firebase.auth().currentUser then firebase.auth().currentUser.sendEmailVerification().then(onReload).catch(onErr)
                        
        # checkout $rootScope.popup message success on login
        onConfirmEmailVerify = ->
                query = $location.search('mode', 'oobCode', 'apiKey')
                $http(method: 'GET',url: '/config').then(->
                        $rootScope.nextRoute = '/'
                        if query.apiKey is config.apiKey
                                firebase.auth().applyActionCode(query.oobCode).then(onReload)
                        else
                                onErr new Error 'apiKey incorrect'
                ).catch(onErr)

        # checkout $rootScope.popup message success on reset password
        onResetPasswordSendEmail = ->
                onReload()
                
        # on Update password
        onUpdatePassword = ->
                onReload()
                
        # on reauthentication, need to be logged or reauthenticated
        onReauthenticate = (user, p1) ->
                user.updatePassword(p1).then(onUpdatePassword).catch onErr
                
        # Reset Password
        onResetPassword = (data) ->
                if document.getElementById('reset_login_password').value is document.getElementById('reset_login_password_confirm').value
                        user = firebase.auth().currentUser
                        pwd  = document.getElementById('reset_login_password_confirm').value
                        onReauthenticate user, pwd


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
                        # Permitido apenas para @itsrio.org e o desenvolvedor
                        if email.match /\w+@itsrio.org/ or email is  "gcravista@gmail.com"
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
                                pwd = randomPassword(16)
                                
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
        $rootScope.onDropdownmenu = (what)->                     
                document.getElementById(what).classList.add('open')
                document.getElementById(what).setAttribute('aria-expanded', 'true')

        $rootScope.onDropupmenu = (what)->
                document.getElementById(what).classList.remove('open')
                document.getElementById(what).setAttribute('aria-expanded', 'false')


        # Dados typeform
        $rootScope.typeformData = null
        $rootScope.searchForm = (options)->
                
        $rootScope.$on '$routeChangeSuccess', (event, next, current) ->
                event.preventDefault();
                console.log $location.url()
                if  $location.url().match /^\/formularios\/\w+\/\w+/
                        $rootScope.onLoading = true
                        query = []
                        uuid = $location.url().split('/formularios/')[1].split('/')[0]
                        query.push "uuid=#{uuid}"
                        query.push "#{k}=#{v}" for k,v of {completed:true, limit:10}
                        _url = "/typeform/data-api?#{query.join('&')}"
                        console.log _url
                        $http({
                                method: 'GET',
                                url: _url
                        }).then (response) ->
                                $rootScope.onLoading = false
                                $rootScope.typeformData = response.data
                                
                
                
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
                        
# Registre o controlador
app.controller "AuthCtrl", ['$rootScope', '$http', '$location', '$window', '$route', onAuth]
