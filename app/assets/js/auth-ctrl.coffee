# Controlador de autenticacao
# TODO Separar os controles    
fetchAuthCtrl = ->
        # A mensagem de carregamento inicial
        # deve ser atualizada
        loader = document.getElementById('masterLoader')
        p = loader.children[9]
        p.innerHTML = "Trabalhando na autorização..."
        AuthCtrl = ($rootScope, $http, $location, $window, $route, authService, toastr) ->

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

                $rootScope.loginGoogle = ->
                        authService.loginGoogle()
                
                $rootScope.loginEmailAndPassword = ->
                        authService.loginEmailAndPassword('input_login_email',
                                'input_login_password',
                                /\w+@itsrio.org|gcravista@gmail.com/)                            

                
                $rootScope.createUserWithEmailAndPassword = ->
                       authService.createUserWithEmailAndPassword('input_signup_email',
                               'input_signup_senha',
                                /\w+@itsrio.org|gcravista@gmail.com/)

                $rootScope.sendPasswordResetEmail = ->
                        authService.sendPasswordResetEmail('reset_login_email')
        
                $rootScope.confirm = -> if $location.url().match /\/confirm\?mode\=[a-zA-Z0-9]+\&oobCode\=[a-zA-Z0-9\_\-]+\&apiKey\=[a-zA-Z0-9]+/ then authService.confirm('reset_login_password', 'reset_login_password_confirm')
                $rootScope.linkAccount = -> authService.linkAccount()
                
                       # Para o menu funcionar corretamente com o bootstrap
                # Vamos adicionar as interações
                $rootScope.onDropdownmenu = (what)->                     
                        document.getElementById(what).classList.add('open')
                        document.getElementById(what).setAttribute('aria-expanded', 'true')
        
                $rootScope.onDropupmenu = (what)->
                        document.getElementById(what).classList.remove('open')
                        document.getElementById(what).setAttribute('aria-expanded', 'false')
                
        new Promise (resolve) -> resolve AuthCtrl
                
