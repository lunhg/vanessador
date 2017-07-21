fetchTypeform = ->
        # A mensagem de carregamento inicial
        # deve ser atualizada
        loader = document.getElementById('masterLoader')
        p = loader.children[9]
        p.innerHTML = "Trabalhando no typeform..."
        TypeformCtrl = ($rootScope, $http, $location, $window, formularios)->

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
                        dialog.save(user, 'danger', "#{err.code}: #{err.message}")
                        
                        # Isso é necessário para reatualizar os dados
                        $window.location.reload()
                        
                # Dados typeform
                $rootScope.typeformData = null                          

                $rootScope.onNovo = (id, groups...) ->
                        f = new formularios()
                        _onNovo = ->
                                $location.path('/formularios')
                                $route.update()
                        f.novo(id, groups).then(_onNovo).catch(onErr)
                        
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
