fetchRun = ->
        # A mensagem de carregamento inicial
        # deve ser atualizada
        loader = document.getElementById('masterLoader')
        p = loader.children[9]
        p.innerHTML =  "Verificando autorizações prévias"
        Run = ($rootScope, $http, $location) ->

                # Dados do usuário
                $rootScope.user = null

                # Dados de um ou vários formularios
                $rootScope.registeredForms = null
                $rootScope.currentForm = null
                $rootScope.questions = {}
                $rootScope.responses = {}
                $rootScope.answers = []
                
                # Variável para dizer se estamos carregando ou não
                $rootScope.onLoading = true

                # Imagem da vanessadora
                $rootScope.defaultPhotoURL = '/assets/images/vanessadora.png'

                # Um token servirá para relacionar uma
                # resposta de um formulário
                $rootScope.token = null
                
                # # Apresentação de dados
                # - /contas
                $rootScope.dadosPessoais = true
                $rootScope.configuracoes = false

                # # Resetar senha de dados
                # - /confirm
                $rootScope.whoisPhoneNumber = true
                $rootScope.confirmCode = false
                $rootScope.resetPassword = false
                $rootScope.verifyEmail = false

                # # Boletos
                # - /boletos
                $rootScope.boletos = []
                
                # ## Boleto
                # - /boleto/:invoiceid
                $rootScope.boleto = null
                
