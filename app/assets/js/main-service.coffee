# Primeiro inicialize as rotas angular atraves
# de templates. Para recuperar esses templates, precisamos
# antes requerilos do servidor.
fetchMainService = ->
        # A mensagem de carregamento inicial
        # deve ser atualizada
        loader = document.getElementById('masterLoader')
        p = loader.children[9]
        p.innerHTML = "Construindo serviço principal..."
        Service =  ($http, $location, $route, $rootScope, $q, toastr) ->

                MainService = {}
                # # Funções auxiliares
                # Estas funções auxiliam as funções principais do $rootScope
                # como chcagem de erro, login, logout, envio de email
                # checkout $rootScope.popup message and type
                MainService.onErr  = (err) ->
                        toastr.error("Erro #{err.code}", err.message)
                        $location.path('/')
                        
                MainService.onTypeformAction = (action, form) ->
                        new Promise (resolve, reject) ->
                                db = firebase.database()
                                db.ref("#{action}/#{form}").once 'value', (r) ->
                                        resolve r.val()               

                MainService._on = (regexpr) ->
                        $q (resolve, reject) ->
                                $rootScope.$on '$locationChangeSuccess', (event, next, current) ->
                                        event.preventDefault()
                                        match = $location.url().match regexpr
                                        if match
                                                resolve match
                                        else
                                                resolve false

                # ## /confirm
                # atualize a base de dados
                # - Firebase: `formularios/`:  `{:uuid => :base_url, :name, :owner, :tags}`
                # - Angular: `$rootScope.registeredForms`
                MainService.onConfirm = (pass) ->
                        $q (resolve, reject) ->
                                if pass
                                        $rootScope.whoisPhoneNumber = true
                                        $rootScope.confirmationCode = false
                                        $rootScope.resetPassword = false
                                        $rootScope.verifyEmail = false
                                else
                                        resolve false
                                
                                        
                # ## /formularios
                # atualize a base de dados
                # - Firebase: `formularios/`:  `{:uuid => :base_url, :name, :owner, :tags}`
                # - Angular: `$rootScope.registeredForms`
                MainService.onFormularios = (pass) ->
                        $q (resolve, reject) ->
                                if pass
                                        fetch = firebase.database().ref('formularios/').once('value')
                                        $q.when(fetch)
                                                .then (snapshot) -> resolve snapshot.val()
                                                .catch (e) -> resolve false
                                else
                                        resolve false
                # ## /formularios/:uuid/:action
                # Captura um formulário com várias respostas
                # - Action
                #   - UUID typeform
                # - Firebase:
                #   - `:action/questions` -- `{:uuid => Array[{:field_id, :id, :question}]}`
                #   - `:action/responses` -- `{:uuid => Array[{:answers, :completed, :metadata, :token}`
                #   - `:action/stats` -- `{uuid => Array[{:completed, :showing, :total}`
                # - Angular: ```$rootScope[:action]```
                MainService.onFormulariosAction = (pass) ->
                        $q (resolve, reject) ->
                                if (pass)
                                        $rootScope.currentForm = pass[0].split('/formularios/')[1].split('/')[0]
                                        action = pass[0].split('/formularios/')[1].split('/')[1]
                                        db = firebase.database()
                                        MainService.onTypeformAction(action, $rootScope.currentForm).then (snapshot) ->
                                                resolve {action: action, val: snapshot}
                                else
                                        resolve false


                # ## /formularios/:uuid/:action/:token
                MainService.onFormulariosActionToken = (pass) ->
                        $q (resolve, reject) ->
                                if pass
                                        
                                        action = pass[0].split('/formularios/')[1].split('/')[1]
                                        $rootScope.token = pass[0].split('/formularios/')[1].split('/')[2]
                                        onQuestions  = MainService.onTypeformAction('questions', $rootScope.currentForm)
                                        onBoletos = MainService.onTypeformAction('boletos', $rootScope.currentForm)
                                        onResponses = MainService.onTypeformAction('responses', $rootScope.currentForm)
                                        $q.all([onQuestions, onBoletos, onResponses]).then (results) ->
                                                questions = results[0]
                                                boletos = results[1]
                                                responses = results[2]

                                                obj = {questions:{}}
                                                if boletos isnt null
                                                        for b in boletos
                                                                if b.token is $rootScope.token
                                                                        if b.status isnt 'CANCELLED'
                                                                                obj.boleto = b 
                                                obj.answers = response.answers for response in responses when response.token is $rootScope.token
                                                obj.questions[q.id] = q.question for q in questions
                                                        
                                                resolve obj
                 # ## /boletos
                MainService.onBoletos = (pass) ->
                        $q (resolve, reject) ->
                                if (pass)
                                        db = firebase.database()
                                        db.ref("boletos/").once 'value', (boletos) ->
                                                if boletos.val() is null
                                                        resolve []
                                                else
                                                        resolve boletos.val()

                MainService.onBoletosInvoice = (pass) ->
                        onBoletos = (bols) -> _b for _b in b when _b.invoice is $rootScope.invoiceid for b in bols
                        $q (resolve, reject) ->
                                if pass
                                        db.ref("boletos/#{$rootScope.currentForm}").once 'value', (boletos) ->
                                                # Pegar o último boleto válido
                                                boleto = null
                                                _boletos = boletos.val()
                                                for b in _boletos
                                                        if b.status isnt 'CANCELLED'
                                                                boleto = b
                                                                break

                                                resolve boleto

                MainService.onVincularPhone = (pass) ->
                        $q (resolve, reject) ->
                                if pass
                                        $rootScope.$watch 'whoisPhoneNumber', ->
                                                container = document.getElementById('recaptcha-container')
                                                Verifier = firebase.auth.RecaptchaVerifier
                                                MainService.applicationVerifier = new Verifier container  
                                                MainService.applicationVerifier.render().then(resolve).catch(MainService.onErr)
                                        
                return MainService
        ['$rootScope', '$location', '$route', '$rootScope', '$q', 'toastr', Service]
