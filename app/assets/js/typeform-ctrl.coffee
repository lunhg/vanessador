fetchTypeform = ->
        # A mensagem de carregamento inicial
        # deve ser atualizada
        loader = document.getElementById('masterLoader')
        p = loader.children[9]
        p.innerHTML = "Trabalhando no typeform..."
        TypeformCtrl = ($rootScope, $http, $location, $window, $controller, toastr, formularioService)->

                # # Funções auxiliares
                # Estas funções auxiliam as funções principais do $rootScope
                # como chcagem de erro, login, logout, envio de email
                # checkout $rootScope.popup message and type
                onErr  = (err) ->
                        console.log err
                        $rootScope.nextRoute = '/'
                        $rootScope.dialogMessage =
                                type: 'danger'
                                text: "#{err.code}: #{err.message}"
                        
                        # Isso é necessário para reatualizar os dados
                        $window.location.reload()

                fetch = ->
                        query = ["/typeform/data-api?"]
                        $rootScope.currentForm = $location.url().split('/formularios/')[1].split('/')[0]
                        query.push "uuid=#{$rootScope.currentForm}"
                        query.push "#{k}=#{v}" for k,v of {completed:true, limit:10}
                        query.join('&')
                        
                # Dados typeform
                $rootScope.typeformData = null                          

                $rootScope.onNovo = (id, groups...) ->
                        _onNovo = -> $location.path('/formularios')
                        formularioService.novo(id, groups, toastr).then(_onNovo).catch(onErr)

                $rootScope.onDelete = (id, name) ->
                        _onDel = ->
                                $rootScope.dialogMessage =
                                        type: 'success'
                                        text: "formulário deletado com sucesso"
                                $location.path('/formularios')
                        _uuid = $location.url().split('/formularios/')[1].split('/')[0]
                        uuid = document.getElementById("#{id}_#{name}").value
                        if _uuid is uuid
                                formularioService.delete(uuid, toastr).then(_onDel).catch(onErr)
                        else
                                onErr new Error("uuid do formulário incorreto")
                                
                # Fake listeners para atualizar
                # os formulários typeform
                # em rotas específicas como
        
                # - /formularios
                if $location.url().match /^\/formularios$/
                        # atualize a base de dados
                        $rootScope.onLoading = true
                        formularioService.getAll (all) ->
                                console.log all
                                $rootScope.registeredForms  = all
                                
                # - /formularios/:uuid/:action
                if  $location.url().match /^\/formularios\/\w+\/\w+$/
                        $rootScope.onLoading = true
                        url = fetch()
                        formularioService.get $rootScope.currentForm, (form) ->
                                $rootScope.currentFormUrl = "https://#{form.base_url}/#{$rootScope.currentForm}"
                                $http.get(url).then (response) ->
                                        $rootScope.typeformData = response.data
                                        $rootScope.onLoading = false
                                        user = firebase.auth().currentUser.uid
                                        firebase.database()
                                                .ref("users/#{user}/currentForm")
                                                .set(response.data)
                                                .catch(onErr)
                                                
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

                #angular.extend this, $controller('AuthCtrl', {$scope:$rootScope})
